# samsung-pinger

Samsung Pinger is a MacOS widget that lets you quickly ring your Samsung device.

![Widget Gallery Screenshot](./docs/preview-widget-gallery.png)

## How it works

You open notification center, click on widget and 1 second later your phone rings!

## Setup

you absolutely can do this! I believe in you! it takes less than 1 minute :)

![Screnshot](./docs/preview-screenshot.png)

1. Download latest release from [downloads page](https://github.com/vityaschel/samsung-pinger/releases) and install it
2. You must obtain 2 tokens from cookies and a persistant "device id" that does not change. Open https://smartthingsfind.samsung.com/
3. Login into your account if needed. Make sure you're at https://smartthingsfind.samsung.com/. Open devtools it with ⌘+⌥+I
4. Go to "Application" tab ![Screenshot](./docs/setup-1.png)
5. Find "Cookies" -> "https://smartthingsfind.samsung.com" at sidebar ![Screenshot](./docs/setup-2.png)
6. In long list find these two cookies: "JSESSIONID", "WMONID". Copy their values to corresponding fields in App's settings ![Screenshot](./docs/setup-3.png) ![Screenshot](./docs/setup-4.png)
7. Reload the page WITHOUT closing devtools
8. Go to "Network" tab in devtools, type "getDeviceList" in Filter field, click on the last (and usually the only) item in list
9. Go to "Response" tab in the opened submenu ![Screenshot](./docs/setup-6.png)
10. Here is a list of all your devices in JSON format. Find the right one (that you want to ping) in this list. Near it's name you will find (`modelName`) — this is called a "property" in JSON format. Locate nearest `dvceID` property in this brackets as shown on screenshot and fill it in the corresponding field. ![Screenshot](./docs/setup-7.png)

## Under the hood

Read [my notes](https://gist.github.com/VityaSchel/fe8945c0189bbaabed420003bdf3216d) on reverse-engineering smartthingsfind website.
