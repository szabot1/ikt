#set text(
  font: "SF Pro Text",
  size: 11pt
)

#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 1.5cm),
)

#set par(
  justify: true,
  leading: 0.52em,
)

#set heading(numbering: "1.")

#show heading: it => [
  #set text(14pt, weight: "semibold")
  #block(it.body)
]

#show heading.where(
  level: 1
): it => [
  #set text(17pt, weight: "bold")
  #block(it.body)
]

// Title page
#[
  #align(center, [
    #figure(
      grid(
        columns: 2,
        gutter: 2mm,
        [#image("img/kkszki.png", height: 80pt)],
        [#image("img/mszc.jpg", height: 80pt)],
      ),
    )
  ])
  
  #align(center + horizon, [
    #text(25pt, font: "SF Pro Display")[*ZÁRÓDOLGOZAT*]
  ])

  #align(bottom, [
    #align(right, [
      #text(15pt)[Készítették:]
      #linebreak()
      #text(13pt)[Szabó Tamás - Gyurkó Levente]

      #text(15pt)[Konzulens:]
      #linebreak()
      #text(13pt)[Németh Bence]
    ])

    #pad(
      top: 2cm,
      [
        #align(center, [
          #text(14pt)[Miskolc]
          #linebreak()
          #text(14pt)[2024.]
        ])
      ]
    )
  ])

  #pagebreak()
]

#[
  #align(center, [
    #text(14pt, fill: blue)[Miskolci SZC Kandó Kálmán Informatikai Technikum]

    #text(14pt, fill: blue)[Miskolci Szakképzési Centrum]

    #text(14pt, fill: blue, weight: "semibold")[SZOFTVERFEJLESZTŐ- ÉS TESZTELŐ SZAK]
  ])

  #align(center + horizon, [
    #text(25pt, font: "SF Pro Display", fill: orange)[*Game Key Store*]

    #text(20pt, font: "SF Pro Display")[projekt feladat]
  ])

  #align(bottom, [
    #align(right, [
      #text(13pt)[Szabó Tamás - Gyurkó Levente]
    ])

    #align(center, [
      #text(14pt)[2023-2024]
    ])
  ])

  #pagebreak()
]

// Outline page
#[
  #align(center + horizon, text(25pt, font: "SF Pro Display")[*Tartalom*])

  #show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }

  #outline(indent: auto, title: "")
  #pagebreak()
]

#set page(
  footer: [
    #set align(right)
    #set text(12pt)
    #counter(page).display("1")
  ]
)

// Development environment
#[
  #let title = [
    Fejlesztői környezet
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #align(center, text(17pt)[
    #heading(title)
  ])

  == Bevezetés
  A fejlesztői környezetünk a modern webes alkalmazások építésére fókuszál, ötvözve a megbízható technológiákat és a legújabb trendeket a front- és backend fejlesztés terén. A backend részleg alapját a Visual Studio biztosítja, amely ASP.NET technológiával van párosítva, így erős és skálázható szerveroldali logikát kínálunk. A Visual Studio Code-ot választottuk a React alapú frontend fejlesztésére, mely gyors és interaktív felhasználói felületek készítését teszi lehetővé.

  Az adatkezelés terén a PostgreSQL-t részesítjük előnyben a MySQL-lel szemben, amely robusztus és megbízható adatbáziskezelő rendszerként szolgál projektjeink számára. Jobban megfelel a komplex adatstruktúrák kezelésére, jobb tranzakciókezelést és fejlettebb adattípusokat kínál. Például a PostgreSQL támogatja a JSON adattípust, amely lehetővé teszi a rugalmas és strukturálatlan adatok hatékony tárolását és lekérdezését, míg a MySQL-ben ez kevésbé intuitív.

  A .NET keretrendszert használjuk a backend fejlesztéséhez, amely széles körű funkcionalitást és teljesítményt kínál, míg az ASP.NET és annak modern változata, az ASP.NET Core, különösen alkalmasak webes API-k és alkalmazások fejlesztésére.

  A frontend területén a Vite szolgál fejlesztői szerverként, amely rendkívül gyors újratöltést és hatékony modulbetöltést kínál a React projektekben. A TypeScript az előnyben részesített nyelv, mivel szigorúbb típusellenőrzést és jobb fejlesztői élményt nyújt, mint a JavaScript. A Reactot a Tailwind CSS-sel párosítjuk, amely egy modern CSS keretrendszer, preferálva azt a Bootstrap helyett az egyedi és reszponzív design megvalósításához.
]

#[
  #let title = [
    Visual Studio, Visual Studio Code
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/vs.png", height: 45pt)],
    ),
  )
  == Visual Studio

  A Visual Studio egy kiemelkedő fejlesztői környezet, amelyet kifejezetten a Microsoft által kínált technológiák, így az ASP.NET alapú webes és vállalati alkalmazások fejlesztésére terveztek. A projektünk fejlesztéséhez a Visual Studio biztosítja azt a rugalmasságot és a teljes körű támogatást, amire szükségünk van a hatékony munkavégzéshez. Az integrált környezet lehetővé teszi számunkra, hogy a kódírást, a hibakeresést, az alkalmazások tesztelését, és a telepítést egyetlen, jól összehangolt felületen végezzük.

  Az ASP.NET projektek fejlesztésének egyik kulcsfontosságú része a NuGet integrációja, amely lehetővé teszi számunkra, hogy könnyen kezeljük a projekt függőségeit és beilleszthessük őket a projektbe. A NuGet segítségével automatikusan kezelhetjük a csomagfrissítéseket, ami jelentősen csökkenti a függőségekkel kapcsolatos problémák kockázatát, és egyszerűsíti a projekt konfigurációját. Innen telepítettük a szükséges csomagokat, mint például az Entity Framework Core-t, amely az adatbázis-kezeléshez szükséges keretrendszer.

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/vsc.jpg", height: 50pt)],
    ),
  )
  == Visual Studio Code

  A Visual Studio Code (VS Code) az egyik legelőnyösebb fejlesztői környezet a React alapú frontend projektekhez. Ennek a könnyű, mégis erőteljes forráskód-szerkesztőnek a kiválasztása elsősorban a JavaScript és TypeScript, két olyan nyelv támogatása miatt történt, amelyek létfontosságúak a React fejlesztésben. A VS Code különösen hasznos funkciókat kínál a React fejlesztők számára, mint például az intelligens kódkiegészítés, a komponensek közötti gyors navigáció és az integrált hibakeresés, ami jelentősen felgyorsítja a fejlesztési folyamatot és javítja a kód minőségét.

  A fejlesztői környezetünk további testreszabását és optimalizálását számos, kifejezetten a React és a modern webfejlesztési munkafolyamatokhoz tervezett VS Code kiterjesztés segíti. Ezek közé tartoznak a linter-ek és kódformázók, mint például az ESLint és a Prettier, amelyek segítenek fenntartani a kódbázis olvashatóságát. Emellett a React specifikus kiterjesztések, mint a React Code Snippets, tovább egyszerűsítik a gyakori minták és komponensek kódolását. Ezek a kiterjesztések jelentősen hozzájárulnak a fejlesztési hatékonysághoz.
]

#[
  #let title = [
    .NET, ASP.NET, ASP.NET Core
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/dotnet.png", height: 45pt)],
    ),
  )
  == .NET
  
  A .NET keretrendszer egy átfogó fejlesztési platform a Microsofttól, amely lehetővé teszi a fejlesztők számára, hogy különféle típusú alkalmazásokat hozzanak létre, beleértve a webes, asztali, mobil-, játék-, és IoT-alkalmazásokat. A platform nyelvfüggetlen, ami azt jelenti, hogy támogatja a különböző programozási nyelveket, mint például a C\#, F\# és Visual Basic. A .NET keretrendszer különösen erős a vállalati szintű webalkalmazások fejlesztésében, köszönhetően az ASP.NET-nek, egy modell-nézet-vezérlő (MVC) architektúrát alkalmazó keretrendszernek, amely lehetővé teszi a dinamikus weboldalak és szolgáltatások kifejlesztését.

  Mi a C\# nyelvet részesítjük előnyben a .NET keretrendszer használatakor, mivel ez a nyelv kifejezetten a .NET-hez lett tervezve. A C\# egy objektumorientált programozási nyelv, amely erős típusosságot, memória kezelést, és lehetővé teszi a fejlesztők számára, hogy biztonságos, hatékony, és könnyen karbantartható kódot írjanak. A C\# nyelv szintaxisa egyszerű és könnyen érthető, ami gyorsítja a fejlesztési folyamatot.

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/aspnet.png", height: 45pt)],
    ),
  )
  == ASP.NET, ASP.NET Core
  
  Az ASP.NET egy erőteljes webfejlesztési keretrendszer a Microsofttól, amely lehetővé teszi a fejlesztők számára, hogy dinamikus weboldalakat, alkalmazásokat és szolgáltatásokat hozzanak létre. Az ASP.NET Core, az ASP.NET modern, keresztplatformos, nagy teljesítményű változata, kifejezetten arra tervezték, hogy könnyen kezelhető és skálázható webalkalmazásokat lehetővé tegyen a .NET Core futtatási környezeten. Az ASP.NET Core kínálja az ASP.NET összes előnyét, miközben további előnyöket biztosít, mint például a keresztplatformos támogatás, a könnyebb konfiguráció, valamint a jobb teljesítmény.

  Mi az ASP.NET Core-t részesítjük előnyben webfejlesztési projektünkben, különösen az Entity Framework Core integrációjával együtt, ami egy erőteljes és rugalmas objektum-relációs leképező (ORM) keretrendszer. Az Entity Framework Core lehetővé teszi számunkra, hogy adatmodelljeinket közvetlenül C\# osztályokban definiáljuk, és az adatbázisműveleteket magas szintű API-k segítségével hajtsuk végre, anélkül, hogy közvetlenül SQL kódot kellene írnunk. Ez nemcsak a fejlesztési folyamatot gyorsítja fel, hanem javítja az alkalmazás karbantarthatóságát is, mivel a kódbázis egyszerűbb és tisztább marad.
]

#[
  #let title = [
    GitHub, JWT
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/github.png", height: 45pt)],
    ),
  )
  == GitHub
  
  Projektünkben a GitHubot használjuk a forráskód tárolására, valamint a fejlesztési munkafolyamatok, mint a hibajavítás, funkciófejlesztés és automatizált telepítések kezelésére. A GitHub Actions, egy kiemelt szolgáltatás a GitHubon, lehetővé teszi számunkra, hogy automatizált munkafolyamatokat állítsunk be, amelyek különböző eseményekre reagálva aktiválódnak, mint a forráskódhoz való hozzáadás (push) vagy a pull requestek.

  A frontend automatikus telepítését a Cloudflare Pages-re, míg a backend automatikus telepítését a Fly.io-ra konfiguráltuk a GitHub Actions segítségével. Ez azt jelenti, hogy minden változás, amely a frontend vagy a backend kódjában történik, és egy adott branch-be kerül, aktivál egy workflow-t, amely automatikusan teszteli, építi, és telepíti az alkalmazásokat az előre megadott platformokra. A Cloudflare Pages ideális választás a statikus frontend alkalmazások gyors telepítésére, míg a Fly.io kiválóan alkalmas a backend API-k nagy rendelkezésre állású és skálázható telepítésére.

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/jwt.png", height: 45pt)],
    ),
  )
  == JWT

  Projektünkben JWT-t használunk a felhasználók hitelesítésére, ami lehetővé teszi számunkra, hogy biztonságos és hatékony hozzáférést biztosítsunk az alkalmazásainkhoz. Egy JWT három részből áll: a fejlécből (header), az adatokból (payload), és az aláírásból (signature), amelyek pontokkal vannak elválasztva egymástól. A fejléc tartalmazza a token típusát, például JWT, és az aláíráshoz használt algoritmust, például HMAC SHA256 vagy RSA.

  Projektünkben a JWT frissítéséhez egy refresh tokent használunk, amely lehetővé teszi a felhasználók számára, hogy új hitelesítési tokent kérjenek anélkül, hogy újra be kelljen jelentkezniük. Ha a frontend alkalmazás egy nem engedélyezett (HTTP 401) választ kap, automatikusan használja a refresh tokent egy új JWT kéréséhez. Ez a megközelítés javítja a felhasználói élményt, mivel a felhasználóknak nem kell gyakran újra bejelentkezniük, miközben fenntartja a rendszer biztonságát azáltal, hogy rendszeresen frissíti a hitelesítési tokeneket.
]

#[
  #let title = [
    Vite, TypeScript, React, Tailwind CSS
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #figure(
    grid(
      columns: 2,
      gutter: 2mm,
      [#image("img/vite.png", height: 40pt)],
      [#image("img/ts.png", height: 40pt)],
    ),
  )
  == Vite, TypeScript
  
  A Vite és a TypeScript kombinációja jelentősen felgyorsítja és optimalizálja a frontend fejlesztési folyamatot projektünkben.
  
  A Vite, egy modern építőeszköz, amely a JavaScript modulok natív ES import export szintaxisát használja a böngészőkben, lehetővé teszi az alkalmazások villámgyors indítását és frissítését fejlesztési időben. Ez ellentétben áll a hagyományosabb eszközökkel, mint például a Create-React-App (CRA), amely hajlamos lehet lassabb indítási időkre és frissítésekre, különösen nagyobb méretű projektjeinknél. A Vite által nyújtott azonnali modulfrissítés (HMR) és a konfiguráció nélküli indulás tovább csökkenti a fejlesztési ciklusokat, lehetővé téve a fejlesztők számára, hogy gyorsabban iteráljanak és teszteljenek.

  A TypeScript, egy JavaScriptre épülő nyelv, statikus típusellenőrzést ad hozzá a dinamikus JavaScript nyelvhez. A projektünkben a TypeScriptet preferáljuk a JavaScripttel szemben, mivel a statikus típusellenőrzés javítja a kódbiztonságot, elősegíti a hibák korai szakaszban történő azonosítását, és növeli a fejlesztési folyamat hatékonyságát. A TypeScript támogatása az intelligens kódkiegészítéshez, refaktoráláshoz és a jobb kódértelmezéshez vezet, ami csökkenti a fejlesztési időt és javítja a kódbázis olvashatóságát és karbantarthatóságát.

  A Vite használata a TypeScripttel különösen előnyös, mivel a Vite kihasználja a TypeScript gyors, inkrementális fordítását, ami lehetővé teszi, hogy a fejlesztők azonnal láthassák a kódjukban végrehajtott változtatások hatását. Ez a kombináció egyaránt támogatja a gyors prototípuskészítést és a nagy teljesítményű alkalmazásfejlesztést, miközben biztosítja a kód minőségét és robustusságát.

  #figure(
    grid(
      columns: 2,
      gutter: 2mm,
      [#image("img/react.png", height: 40pt)],
      [#image("img/tw.png", height: 40pt)],
    ),
  )
  == React, Tailwind CSS

  A React lehetővé teszi a dinamikus és interaktív felhasználói felületek hatékony építését a weben. Ennek a könyvtárnak az alkalmazása számos előnyt kínál, amelyek közvetlenül hozzájárulnak a fejlesztési folyamat javításához és a végtermék minőségének növeléséhez.

  A Bootstrap-tel szemben, amely előre meghatározott stílusú komponenseket kínál, a Tailwind CSS egy "utility-first" megközelítést alkalmaz, ami azt jelenti, hogy kis, újrafelhasználható stílusosztályokat biztosít, amelyeket közvetlenül a HTML elemekhez rendelhetünk. Ez a megközelítés nagyobb mértékű testreszabhatóságot és finomhangolást tesz lehetővé, anélkül, hogy aggódnunk kéne a felesleges CSS kód vagy stílusütközések miatt. Ezenkívül a Tailwind CSS segítségével könnyen létrehozhatók reszponzív designok, mivel a keretrendszer "mobile-first" megközelítést követ és rendelkezik számos reszponzív segédosztállyal.

  Egy másik fontos szempont, amiért a Tailwind CSS-t preferáljuk a Bootstrap-pel szemben, az a teljesítmény. A Tailwind lehetővé teszi, hogy csak azokat a stílusokat építsük be, amelyeket ténylegesen használunk, csökkentve ezzel az alkalmazásunk végső CSS méretét.
]

// User documentation
#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #align(center, text(17pt)[
    #heading(title)
  ])

  == Regisztráció

  A regisztráció eléréséhez elősször látogassuk meg az oldalt az alábbi linken.A főoldal elérésével, az oldalon a jobb felső sarokban a register szöveg megnyomása során elérjük a következő oldalt amit az alábbi képen láthatunk:

  #align(center, [#image("img/registerpage.png", height: 35%, width: 65%, fit: "stretch")])

  A regisztrációs oldalon az adataink kitöltésével tudunk beregisztrálni az oldalra.Az email address résznél a saját egyénileg használt email fiókunkat kell megadni.A username résznél egy egyedileg választott felhasználó nevet adhatunk meg amit az oldalon való bejelentkezés során mindenki megtekinthet.
  A password részeket egyedileg választott jelszavunkat adhatjuk meg, ami fontos hogy semmilyen körülmények között se adjuk meg másoknak a jelszavunkat.

  #align(center, [#image("img/fillregisterpage.png", height: 35%, width: 65%, fit: "stretch")])

  Amint kitöltöttük az adatainkkal a regisztrációs formátumot, abban az esetben nyomjunk rá a *Continue* gombra.

  === Regisztráció megerősítése emailben.

  Amint a *Continue* gombra rányomtunk, a következő oldalt fogja behozni nekünk.

  #align(center, [#image("img/registeremailverify.png", height: 35%, width: 65%, fit: "stretch")])

  Az oldalon a megadott email címünkre érkezett kóddal tudjuk megerősíteni a regisztrációnkat.
  A következő email-t fogjuk kapni a megadott email címünkre.

  #align(center, [#image("img/verifyemail.png", height: 31%, width: 100%, fit: "stretch")])

  Az emailre kapott kódot írjuk vagy illeszük be az Email code részbe majd nyomjunk rá a *Continue* gombra.
  Ezek után az oldal átdob a bejelentkezés menüpontra, ahonnan már betudunk jelentkezni a létrehozott accountunkba.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Bejelentkezés

  A bejelentkezés lehetősége az oldal főoldalán található a jobb felső sarokban, még a regisztráció előtt. Kattintsunk a Sign in gombra, és a következő oldalon találjuk magunkat, ahol lehetőségünk van bejelentkezni vagy létrehozni egy fiókot az oldalon. Ez az elrendezés segíti a felhasználókat egyszerűen és gyorsan hozzáférni a fiókjukhoz vagy regisztrálni az oldalon.

  #align(center, [#image("img/signinpage.png", height: 30%, width: 70%, fit: "stretch")])

  Az oldalon az Email address résznél adjuk meg a regisztrációnál használt email címünket a bejelentkezési oldalon. A megadott jelszóval pedig lépjünk be a Continue gomb segítségével. Ha még nem regisztráltunk fiókot, kattintsunk a világos zöld Register here szövegre. Ez a folyamat segít biztosítani, hogy könnyen hozzáférjünk az oldalhoz, és lehetőségünk legyen regisztrálni, ha még nem tettük meg.
  
  A sikeres bejelentkezést követően a felhasználó neve és az avatárja megjelenik a jobb felső sarokban. Ez a funkció segít az azonosításban és a felhasználói élmény személyre szabásában, lehetővé téve, hogy könnyen és gyorsan hozzáférjünk a fiókunkhoz és az ehhez kapcsolódó funkciókhoz az oldalon.

  #align(center, [#image("img/loggedin.png", height: 32%, width: 110%, fit: "stretch")])
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Felhasználói profil

  Ha a felhasználó nevére kattintunk, további funkciókat érhetünk el. Az első pontban megtekinthetjük a profilunk oldalát, ahol információkat tekinthetünk meg rólunk és beállíthatunk linkeket a profilunkhoz. A második menüpontban különböző beállításokat tehetünk a felhasználói fiókkal kapcsolatban, melyek elérhetők a Settings menüpont alatt. A harmadik menüpont segítségével pedig kijelentkezhetünk a felhasználói fiókból, amennyiben szükséges. Ezek a lehetőségek segítenek a felhasználónak teljes körűen kezelni és testre szabni az online jelenlétét és fiókját a platformon.

  #align(center, [#image("img/Profilebar.png", height: 20%, width: 40%, fit: "stretch")])
  
  === Profile rész

  #align(center, [#image("img/profilepage.png", height: 25%, width: 40%, fit: "stretch")])

  *Szintlépés*

  A vásárlásokhoz kapcsolódó szintlépések lehetőséget adnak arra, hogy a vásárlások révén megszerezz magasabb szinteket a felhasználói profilodban, ami további előnyöket és funkciókat jelenthet számodra.
  
  Vásárolj termékeket vagy szolgáltatásokat az alkalmazásunkban a szokásos módon.
  
  Minél több vásárlást hajtasz végre, annál több pontot vagy "szintet" szerezhetsz.
  A vásárlások után ellenőrizd a profilodat, hogy lássad, elérted-e az új szintet, és milyen előnyökkel jár ez a szintlépés.

  *Social Link beszúrása*

  Ahhoz, hogy a közösségi kapcsolatokat hozzáadhassuk a felhasználóhoz, először kattintsunk a képen látható ceruza ikonra, majd ott a megfelelő mezők kitöltésével tudunk különböző külső közösségi fiókokat hozzáadni a felhasználó profiljához. Ezáltal lehetőségünk van bővíteni a kapcsolati hálónkat és jobban összekapcsolódni más felhasználókkal a közösségi platformokon keresztül.

]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Settings

  #align(center, [#image("img/accountsettingspage.png", height: 20%, width: 110%, fit: "stretch")])

  Az oldal Settings menüpontja alatt két fontos beállítás érhető el. Az első menüpont segítségével lehetőségünk van véglegesen törölni a felhasználói fiókot, melyhez a Delete account gombot kell használnunk. A második menüpontban pedig lehetőségünk van beállítani fizetési adatainkat az oldalon, hogy későbbi vásárlásaink során automatikus és gyors fizetést biztosíthassunk. Ezek a beállítási lehetőségek segítenek biztosítani az oldalon való zavartalan és testreszabott felhasználói élményt mindenki számára.

  == Seller Dashboard

  #align(center, [#image("img/sellerdashboard.png", height: 20%, width: 110%, fit: "stretch")])

  A Seller Dashboard megoszlása két diszkrét részre teremt strukturált és hatékony tájékozódást az eladók számára. Az első rész, melyet a Profile szekció képvisel, olyan mélységes betekintést nyújt az eladói profilba, amely lehetővé teszi az átfogó és precíz személyes beállításokat. E rész integritását és funkcionalitását tovább erősíti az Offer részleg, mely az ajánlatok és termékek központja.

  === Seller Profile részleg

  A Profile szakasz magában foglalja az eladó teljes bemutatását, ahol finomított és testre szabott beállításokat végezhet a Profil menü ceruza ikonjának finom megérintésével. Ez az elérhetőség a Profil részletek gondos kezelését, valamint az azokhoz való hozzáférést biztosítja. Az avatár alatt, a személyes azonosításában rejlő biztonsági rétegek között, a seller statuszát ragyogja fel, amely megkülönbözteti az Unverified és a Verified státuszt, jelentősége pedig a megbízhatóság és a hitelesség kiemelésében rejlik.

  === Seller Offer részleg

  Az Offer részleg pedig a dinamikus termékkínálat és az üzleti lehetőségek színtere. A + gombra kattintva hozzáadhatja újabb árucikkeit az ajánlott termékek piacához, ezáltal növelve a kínálat és a potenciális üzleti értékét. A jelenleg kínált termékek pedig egy áttekinthető listán jelennek meg, amely lehetőséget nyújt a könnyű navigációra és a kínálatban való eligazodásra a next és previous navigációs opciókkal. Ezzel egyidejűleg támogatva az üzleti stratégiák finomhangolását és a piaci jelenlét hatékony kezelését.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Seller Dashboard eladás

  #align(center, [#image("img/addoffer.png", height: 30%, width: 60%, fit: "stretch")])

  A Seller Dashboardon, az Offer részleg belül, a plusz jelre való kattintással érjük el a következő moduláris egységet, melyben árucikkeinket eladásra bocsátani lehetőség nyílik. Ebben az interaktív térben számos lehetőség áll rendelkezésre az eladás folyamatának gördülékeny kezelésére.

  Először is, a Select a game legördülő menüjéből kiválasztjuk az eladásra szánt játékot, lehetővé téve a specifikus termék kijelölését és az eladói kínálat pontos meghatározását. Ezután, a Select a delivery type lehetőségében kiválasztjuk azt a szállítási típust, amely a vevő számára elérhetővé válik (például: Steam kulcs), biztosítva ezzel a tranzakció folyamatának személyre szabott és az elvárásoknak megfelelő kiszolgálását.

  A végén, az utolsó sorban megadhatjuk az eladott árucikk árát, lehetővé téve a piaci versenyképesség fenntartását és az áralku számára megfelelő alapot. Ezt követően, végső lépésként, a Create offer gombra kattintva rögzíthetjük az ajánlatot, elősegítve ezzel a tranzakció zökkenőmentes lebonyolítását és az üzleti lehetőség gyors és hatékony kiaknázását.

  *Sikeres ajánlat esetén*

  A sikeres játékajánlat létrehozását követően az oldal jobb alsó sarkában felbukkanó szöveges üzenettel találkozhatunk, mely a tranzakció sikeres rögzítését és az eljárás eredményes lezárását igazolja. Ez a felugró szöveg, mintegy virtuális pecsét, megerősíti az eladó által végrehajtott tevékenység sikerét, egyúttal biztosítva a felhasználót az elkötelezettség és a stabilitás érzésében.

  #align(center, [#image("img/offercreated.png", height: 10%, width: 60%, fit: "stretch")])
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Seller Dashboard Add Stock
  
  Amikor árucikkeid kifogytak, a rendszer azonnal alternatív megoldásokat kínál számodra. A következő ajánlások egy új dimenziót nyitnak meg az eladási potenciálodban.

  Ehhez a felfedezéshez csak annyit kell tenned, hogy a doboz ikonra kattintasz, amelyet a képernyőn láthatsz. Ez a kattintás vezet el az "add stock/restock" részhez, ahol lehetőséged nyílik új készletet hozzáadni vagy újabb kulcspárokat betenni a kifogyott készletedbe. Ez a dinamikus és gyors reakció lehetőséget biztosít arra, hogy folyamatosan kielégítsd a keresletet és maximalizáld az eladási potenciált, így folyamatosan növelve a sikeres tranzakciók számát és az üzleti lehetőségek hatékonyságát.

  #align(center, [#image("img/randomoffer.png", height: 5%, width: 100%, fit: "stretch")])

  #align(center, [#image("img/addstock.png", height: 30%, width: 60%, fit: "stretch")])
  
  A Seller Dashboard "add stock" része egyszerű és hatékony működésű. Csak egyszerűen írd be a megfelelő kulcspárokat a jól látható mezőbe, majd az "add stock" gomb megnyomásával azok azonnal hozzá lesznek adva az ajánlathoz. Ez az egyszerű és intuitív felület lehetővé teszi, hogy gyorsan és hatékonyan frissítsd a készleted, minimalizálva ezzel az időveszteséget és maximalizálva az eladási lehetőségeket.
  
  == Alapvető funkciók az oldalon
  
  === Searchbar

  A kereső sávot, más néven Searchbart, a weboldal Search Games menüpontja alatt helyezték el, ahol könnyedén elérhetővé válik a keresés funkció. Amikor ezt a menüpontot választjuk, az oldal egy új ablakot nyit meg, amely lehetőséget biztosít arra, hogy szabadon böngésszünk és kutassunk az elérhető játékkulcsok között.

  A kereső sávba írva a kívánt termék nevét vagy kulcsszavait, lehetőségünk van megtalálni a megfelelő játékot vagy terméket. Miután befejeztük a gépelést, egyszerűen nyomjunk entert, és az oldal azonnal megjeleníti a releváns találatokat. Ezután csak ki kell választanunk a keresett játékot a listából, és további részletekért rá kell kattintanunk a megfelelő szövegre.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Játék vásárlás

  Miután megtaláltuk a keresett játékot és rákattintottunk, két különböző helyzettel találhatjuk szembe magunkat. Az első esetben, amennyiben a kiválasztott játékhoz elérhető Steam kulcs van eladó, ezt azonnal láthatjuk. A második esetben pedig azt tapasztaljuk, hogy a megvásárolni kívánt játékhoz nincs elérhető kulcspár eladó.

  Ez a megosztott élmény lehetővé teszi számunkra, hogy áttekintsük az eladásra kínált játékok aktuális állapotát és azok elérhetőségét. Így könnyedén dönthetünk arról, hogy melyik játékot választjuk, és szükség esetén azonnal megvásárolhatjuk vagy további lépéseket tehetünk annak érdekében, hogy megszerezzük a kívánt játékot.

  *Vehető kulcspár*

  #align(center, [#image("img/available offers.png", height: 15%, width: 100%, fit: "stretch")])

  *Nincs eladásra kínált kulcspár*

  #align(center, [#image("img/nooffers.png", height: 16%, width: 100%, fit: "stretch")])

  *Vehető kulcspár esetén*

  Amennyiben döntünk a kulcs vásárlása mellett, az első képen látható, hogy az eladó neve és státusza, mely lehet Verified vagy Unverified Seller, egyaránt feltűnik. E mellett az árat is láthatjuk, mely dollárban értelmezendő.

  Az eladó státusza és az ár alapján választhatunk a számunkra megfelelő ajánlat közül, figyelembe véve a megbízhatóságot és az ár-érték arányt. Miután kiválasztottuk az ideális ajánlatot, egyszerűen kattintsunk a "Purchase" gombra az offer mellett, és így folytathatjuk a vásárlási folyamatot.

  Ez a folyamat biztosítja számunkra, hogy tudatos döntéseket hozzunk az ajánlatok között, miközben egyszerűen és hatékonyan folytathatjuk az eladóval való kommunikációt és a vásárlási tranzakciót.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Fizetési instrukciók

  #align(center, [#image("img/Stripe.png", height: 60%, width: 80%, fit: "stretch")])

  Miután rákattintottunk a vásárlás gombra, megjelenik a Stripe fizetési ablaka. Ide kell beírnunk a bankkártya adatainkat, mint például a számot, a lejárati dátumot és a háromjegyű biztonsági kódot. Emellett lehetőség van megadni a nevet és akár a telefonszámunkat is, bár ez opcionális. Amikor mindent kitöltöttünk, egyszerűen csak megnyomjuk a fizetés gombot, és a tranzakció lezárul.
]

#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()

#[
  Linkek
]