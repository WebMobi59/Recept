#APPoteket iOS - Recept-app

## Generellt

Hybridapp skriven i Swift för iOS. Appskalet laddar ner en zip-fil från remote som innehåller template-filer för appens grafiska maner, och sen fås det personliga datat asynkront från API:er.

## TeamCity

Projektet finns upplagt i TeamCity (APPoteket-iOS).

TeamCity bygger projektets workspace och testar det test-projekt som finns i XCode-projeket, idag innehållande endast några få unit-tester som mall - Kompletteras med andra ord väldigt gärna.

## App-store-konton

Info på wiki.

Vi har både Enterprise- och ett vanligt Company-konto. Så för utveckling och intern release (acceptans) använder vi Enterprise-kontot, Company-konto endast för release.

## Test av appen

Med VPN kan man surfa till https://rxapp-download.apoteket.se/ och ladda ner den version man är intresserad av. Genom den sajten distribuerar vi versioner till AT och dev för intressenter. Samt härifrån är också tanken att man ska ladda ner produktions-versionen som ska till App Store.

## Release av ny version

FYI: Apple har haft problem med Swift och automatiska byggen (swift-support-katalogen har saknats i IPA:n), så vi har behövt köra release genom XCode trots allt. Dock ska det fungera enligt nedan, för att undvika diffar mellan utvecklingsmiljöer. Så prova nedanstående först.

Görs INTE från XCode, iom att vi vill köra alla byggen genom TC för att få en och samma maskin som alltid gör bygget.

Gå till https://rxapp-download.apoteket.se/ och ladda ner "Release - Endast för App Store". Den innehåller version som taggats från TC, så vill man ha en specifik version får man gå in i TC och ändra första byggstegets versionstaggning till en ny version som man vill ha. Alternativt kan man sätta version hårt i versionsbump-steget i 2. Create binaries and install assets. Kom ihåg att Octopus dock inte kan releasa samma version flera gånger.

Öppna Application Loader (v3+), logga in med app-store-admin@apoteket.se (lösen finns i wiki) och ladda upp .ipa-filen genom den. Kontrollera så att samma version vi draftar i app-store är den versionsnummer vi har på .ipa-filen.

## iTunes-credentials

Finns på wikin under rubriken "Appar iOS". app-store-admin@apoteket.se (App Store) och app-store@apoteket.se (Enterprise).

## Utvecklingsmiljö
Vi kör Swift 2.x för utveckling huvudsakligen och CocoaPods-projekt (just nu Objective C-projekt) som dependency resolution.

Prereq:
- XCode 7+: Hämtas från app store
- [Cocoapods](https://guides.cocoapods.org/using/getting-started.html)

Uppsättning:
1. Öppna XCode. Installera command line tools om det frågas, ev. extra simulator som man vill ha.
2. Klicka på menyn XCode->Preferences...
3. Lägg till nytt apple-id genom att klicka på plus nere till vänster i fönstret
4. Lägg till app-store-admin@apoteket.se samt app-admin@apoteket.se (lösenord finns i wiki)
5. För respektive konto i Accounts-fönstret, klicka på Team Name "Apoteket AB" och därefter "View Details" nere till höger
6. Klicka på Download All längst nere till vänster för att ladda ner samtliga Provisioning Profiles
7. Exportera samtliga Distribution Certs och cert som heter ngt med "Ani Kurteva" (devcert) från Keychain Access på byggservern (skulle ngt cert saknas kan man alltid revoka ett cert i Apple Member Center och skapa ett nytt, men då måste dessa också installeras på byggservern)
8. Importera dessa cert på din egen dator
9. Stäng av XCode

Se därefter till att du har CocoaPods och git-projektet på datorn med följande kommandon:
```
sudo gem install cocoapods
git clone http://git.apoteket.se/appoteket.ios.git
cd appoteket.ios
```

Öppna Workspace-filen som finns i mappen i XCode.

För att vara säker på att alla cert installerats korrekt, klicka på Recept-projektet och välj fliken "Build Settings". Sök på "signing" och kontrollera så att du har "human readable"-names på Code Signing Identity-värdena samt Provisioning Profile-värdena. Om inte kan det bero på att ngt cert inte installerats korrekt eller att du inte laddat ner samtliga provisioning profiles. Kontrollera också ifall det eventuellt finns giltiga provisioning profiles i dropdown-listan om du klickar på en rad som ser konstig ut.

Ser allt ok ut ska det nu bara vara att köra projektet: Använd respektive target för den miljö du vill köra. Recept-Debug går mot localhost.apoteket.se:3001 där vi hostar zip-templates från appoteket.ui-projektet när man kör det med Grunt. De andra (Recept-Test, Recept-Production, Recept-Release, Recept-Dev) går mot respektive test-miljö som kräver VPN alternativt produktion som går mot live-miljön. Dessa är konfigurerade genom respektive plist i Recept->Configuration->Configuration.<env>.plist.

## Uppsättning TeamCity, XCode

Hoppa in i TeamCity, klicka på "Agents", klicka på "Install Build Agents", välj "Zip file distribution".
I samma popup-dialog som Zip-länken finns en länk till dokumentation för agenter. Klicka på den och följ den för att regga agent till TC-mastern och för att starta build-agenten.

I stort var det inga större problem att köra projektet genom TeamCity (se OBS nedan). Det som behövs:
- En build-agent som kör MacOSX med XCode (xcodebuildtools) installerat
- Ett schema som TeamCity kör och testar på
- Sätta upp en specifik build pool som bara iOS-delarna använder (för att inte behöva vara agent för alla byggen)

Build-agent guide: 
https://confluence.jetbrains.com/display/TCD9/Xcode+Project#XcodeProject-scheme
https://confluence.jetbrains.com/display/TCD8/Assigning+Build+Configurations+to+Specific+Build+Agents

### OBS:
För att få projektet att fungera tillsammans med CocoaPods var jag tvungen att:
1. Ändra "VCS checkout mode" till "Automatically on agent (if supported by VCS roots)" för bygget/testerna
2. Ha ett nytt "Shared" schema i projekets workspace (viktigt att target är none, så det hör till workspace och inte till det specifika approjektet, annars hittar build-agent inte rätt i "Check & Parse" i setupen)

## Köra en egen distribueringsservice
Kräver: 
- node/npm
- Python
- XCode (xcodebuild tool)
- Möjlighet att signa iOS-arkiv för enterprise-dist

Gå in i mappen DistService, kör:
npm install

Därefter något av följande:
grunt buildDebug (för att bara bygga ut debug-versionen av projektet och tillhörande filer)
grunt server (för att starta en service för att installera root-cert samt en SLL-service self-signed för att tanka hem appen)
grunt (för att göra båda ovanstående samtidigt)



#Recept
