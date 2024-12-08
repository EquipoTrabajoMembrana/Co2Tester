// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

import {createClient} from 'npm:@supabase/supabase-js@2'

import {JWT} from 'npm:google-auth-library@9'

//lO QUE NOS INTERESA GUARDAR EN EL PAYLOAD LO DEFINIMOS EN UNA INTERFAZ, EN ESTE CASO SE REQUIERE GUARDAR EL NOMBRE DEL DISPOSITIVO Y EL NIVEL DE CO2 QUE SE INSERTO A ESE DISPOSITIVO.
interface User {
  name: string
  fmc: string
  co2_level: number  
}

//EN ESTA PARTE VAMOS A GUARDAR LOS DATOS DE LA TABLA EN EL RECORD DE USER, ANTERIORMENTE DEFINIMOS USER PARA GUARDAR LO QUE OBTENDREMOS DEL PAYLOAD, EN ESTE CASO DE LA TABLA DEVICES.
interface WebHookPayload {
  type: 'INSERT'
  table: string
  record: User
  schema: 'public'
  old_record: null | User
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  try {
    const payload: WebHookPayload = await req.json();

    // Enviar la notificación cuando se detecte un nuevo dispositivo añadido, EN ESTA FUNCION SE REALIZARAN VARIAS VERIFICACIONES, ENTRE ELLAS SI A LA HORA DE INSERTAR ES EN LA TABLA DEVICE Y DESPUES DE ESO VERIFICA SI EL VALOR ES IGUAL O MAYOR A MIL PARA ENVIAR LA NOTIFICACION.
    if (payload.type === 'INSERT' && payload.table === 'devices') {
      const { co2_level, name } = payload.record;

      if (co2_level >= 1000) {
        await sendNotificationToTopic(
          "Alerta de CO2",
          `El dispositivo ${name} tiene un nivel de CO2 alto: ${co2_level} ppm.`
        );
      }
    }

    return new Response('Notificación enviada', { status: 200 });
  } catch (error) {
    console.error(error);
    return new Response('Error procesando el evento del webhook', { status: 400 });
  }
});

// Función para enviar notificación a un topic, IMPORTAMOS EL SERVICE-ACCOUNT PROPORCIONADO POR FIREBASE PARA ACCEDER A LOS PARAMETROS NECESARIOS
const sendNotificationToTopic = async (title: string, body: string) => {
  const { default: serviceAccount } = await import(
    "../service-account.json",
    { with: { type: "json" } }
  );

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  });

  //EN ESTA FUNCION ENVIAREMOS LA NOTIFICACION, COMO ANTERIORMENTE VIMOS, FIREBASE NOS PROPORCIONA EL ARCHIVO PARA PODER HACER LAS IMPORTACIONES EN ESTE CASO DE NUESTRO PROYECTO Y NUESTRO TOKEN, PARA PODER REALIZAR EL LLAMADO A LA NOTIFICACION
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          topic: "all_devices",
          notification: {
            title,
            body,
          },
        },
      }),
    }
  );

  const resData = await res.json();
  if (res.status < 200 || res.status > 299) {
    console.error("Error enviando notificación:", resData);
    throw new Error("No se pudo enviar la notificación al topic.");
  }

  return resData;
};

// Función para obtener el token de acceso
const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token);
    });
  });
};


// Deno.serve(async (req) => {
 
//   const payload: WebHookPayload = await req.json()

//   const {data} = await supabase.from('profiles').select('fcm_token').eq('id', payload.record.profile_id).single()

//   const fcmToken = data!.fcm_token as string

//   const {default: serviceAccount} = await import('../service-account.json', {
//     with: {type: 'json'}
//   })

//   const accessToken = await getAccesToken({
//     clientEmail: serviceAccount.client_email,
//     privateKey: serviceAccount.private_key
//   })

//   const res = await fetch(
//     'https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send',
//     {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         Authorization: 'Bearer ${accessToken}',
//       },
//       body: JSON.stringify({
//         message:{
//           token: fcmToken,
//           notification:{
//             title: 'Token',
//             body: '${payload.record.id}'
//           },
//         },
//       }),
//     }
//   )

//   const resData =  await res.json()
//   if(res.status < 200 || 299 < res.status) {
//     throw resData;
//   }

//   return new Response(
//     JSON.stringify(resData),
//     { headers: { "Content-Type": "application/json" } },
//   )
// })

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/notifications' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/

// const getAccesToken = ({
//   clientEmail,
//   privateKey,
// }: {
//   clientEmail: string
//   privateKey: string
// }): Promise<string> => {
//   return new Promise((resolve, reject) => {
//     const jwtClient = new JWT({
//       email: clientEmail,
//       key: privateKey,
//       scopes:[
//         'https://www.googleapis.com/auth/firebase.messaging'
//       ],
//     })
//     jwtClient.authorize((err,tokens)=>{
//       if(err){
//         reject(err)
//         return;
//       }
//       resolve(tokens!.access_token)
//     })
//   })
// }