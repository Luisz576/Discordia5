# discordia5

Um App flutter para conversar em call com amigos e mandar mensagem. Porém, todo mundo é Admin, então tome cuidado...

## Build

Para que o aplicativo seja compilado corretamente você precisará:
1. Criar, dentro da pasta "utils", um arquivo com o nome "agora.io.dart" e adicionar a seguinte linha de código (substituindo pelo seu APP_ID):

    <code>const String AGORA_APP_ID = "APP_ID";</code>

2. Criar e conectar com um projeto firebase (será gerado o "firebase_options.dart")
OBS: Você deve ativar o Realtime Database + o Storage

Com tudo configurado basta rodar o seguinte comando para gerar o .apk do aplicativo:

<code>flutter build apk</code>
