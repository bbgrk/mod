# MoD Webhook Message Upsert

- Webhookal upsertelni bejegyzéseket
- Egyszerű json és egy powershell script segítségével
- **Webhook url-t soha se commitold a repóba!**
- **Upsert:** Az Insert (POST) és Update (PATCH) összevonva. Ha nem létezik létrehozza, ha létezik felülírja.
- Akkor tudja, hogy létezik, ha meg van advan a `messageId` mező is.
- Amikor új az üzenet, akkor a `messageId` legyen `null`.
  
## Használat

### Content létrehozása

- Használd ezt: https://discohook.app/
- Ha kész vagy, akkor `Options -> JSON Editor`
- Másold ki az egészet és rakd be az adott json fájlodba

### Message küldése - Powershell

- Nyiss egy powershell terminált
- Webhook url természetesen cseréld ki

```powershell
PS C:\DATA\github\mod> .\upsert.ps1 -JsonPath .\dicsosegfal1.json -WebhookUrl https://discord.com/api/webhooks/nnnnnnnnnnnnn/sssssssssssssssssssssssssss
```

### Message küldése discohook-kal

- https://discohook.app/
- Ezzel is lehet, de körülményesebb, mert a messageId-t kell linkelgetni

## Példa json

- Üzenetek tömbje. Array of messages

```json
[
    {
        "messageId": null,
        "messageContent": {
            "content": "Ez már a discord üzeneted."
        }
    }
]
```

## Discord docs

- https://docs.discord.com/developers/resources/webhook#execute-webhook
- https://docs.discord.com/developers/resources/message
- https://docs.discord.com/developers/resources/message#embed-object

## License

WTFPL