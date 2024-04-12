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

  A .NET keretrendszert használjuk a backend fejlesztéséhez, amely széles körű funkcionalitást és teljesítményt kínál, míg az ASP.NET és annak modern változata, az ASP.NET Core, különösen alkalmasak webes API-k és alkalmazások fejlesztésére.

  A frontend területén a Vite szolgál fejlesztői szerverként, amely rendkívül gyors újratöltést és hatékony modulbetöltést kínál a React projektekben. A TypeScript az előnyben részesített nyelv, mivel szigorúbb típusellenőrzést és jobb fejlesztői élményt nyújt, mint a JavaScript. A Reactot a Tailwind CSS-sel párosítjuk, amely egy modern CSS keretrendszer, preferálva azt a Bootstrap helyett az egyedi és reszponzív design megvalósításához.

  Az adatkezelés terén a PostgreSQL-t részesítjük előnyben a MySQL-lel szemben, amely robusztus és megbízható adatbáziskezelő rendszerként szolgál projektjeink számára. Jobban megfelel a komplex adatstruktúrák kezelésére, jobb tranzakciókezelést és fejlettebb adattípusokat kínál. Például a PostgreSQL támogatja a JSON adattípust, amely lehetővé teszi a rugalmas és strukturálatlan adatok hatékony tárolását és lekérdezését, míg a MySQL-ben ez kevésbé intuitív.

  #align(center, [#image("db.png", height: 50%, width: 90%, fit: "stretch")])
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

  A Visual Studio Code (VS Code) az egyik legelőnyösebb fejlesztői környezet a React alapú frontend projektekhez. Ennek a könnyű, mégis erőteljes forráskód-szerkesztőnek a kiválasztása elsősorban a TypeScript támogatása miatt történt, ami létfontosságú a React fejlesztésben. A VS Code különösen hasznos funkciókat kínál a React fejlesztők számára, mint például az intelligens kódkiegészítés, a komponensek közötti gyors navigáció és a beépített hibakeresés, ami jelentősen felgyorsítja a fejlesztési folyamatot és javítja a kód minőségét.

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
  
  A .NET keretrendszer egy fejlesztési platform a Microsofttól, amely lehetővé teszi a fejlesztők számára, hogy különféle típusú alkalmazásokat hozzanak létre, beleértve a webes, asztali, mobil-, és játék-alkalmazásokat. A .NET keretrendszer különösen erős a vállalati szintű webalkalmazások fejlesztésében, köszönhetően az ASP.NET-nek, amely lehetővé teszi a dinamikus weboldalak és szolgáltatások kifejlesztését.

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

  Mi az ASP.NET Core-t részesítjük előnyben webfejlesztési projektünkben, különösen az Entity Framework Core integrációjával együtt, ami egy erőteljes és rugalmas ORM keretrendszer. Az Entity Framework Core lehetővé teszi számunkra, hogy adatmodelljeinket közvetlenül C\# osztályokban definiáljuk, és az adatbázisműveleteket magas szintű API-k segítségével hajtsuk végre, anélkül, hogy közvetlenül SQL kódot kellene írnunk. Ez nemcsak a fejlesztési folyamatot gyorsítja fel, hanem javítja az alkalmazás karbantarthatóságát is, mivel a kódbázis egyszerűbb és tisztább marad.
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
      [#image("img/cf.png", height: 85pt)],
    ),
  )
  == Cloudflare Pages

  A Cloudflare Pages egy statikus weboldalak tárolására és telepítésére szolgáló platform, amely kifejezetten a modern webfejlesztési keretrendszerek igényeihez igazodik, mint például a React. A Cloudflare globális CDN-jének köszönhetően a Pages szupergyors betöltési sebességet biztosít világszerte, javítva ezzel a felhasználói élményt. Az automatizált telepítési folyamatok, mint a push eseményekre reagáló automatikus build-ek és deploy-ok, egyszerűsítik a fejlesztési ciklusokat.

  #figure(
    grid(
      columns: 1,
      gutter: 2mm,
      [#image("img/flyio.png", height: 25pt)],
    ),
  )
  == Fly.io

  A Fly.io egy alkalmazás-telepítési platform, amely a fejlesztőknek lehetőséget biztosít arra, hogy alkalmazásunkat egy docker konténerben futtassuk. A platform különösen alkalmas dinamikus backend szolgáltatások, mint API-k és mikroszolgáltatások hostingjára. A GitHub Actions integrációjának köszönhetően a fejlesztők konfigurálhatják az alkalmazásaik automatikus telepítését és frissítését válaszul a kódbázisban történő változásokra.
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
  
  A Vite, egy modern építőeszköz, amely a JavaScript modulok natív ES import export szintaxisát használja a böngészőkben, lehetővé teszi az alkalmazások villámgyors indítását és frissítését fejlesztési időben. Ez ellentétben áll a hagyományosabb eszközökkel, mint például a Create-React-App (CRA), amely hajlamos lehet lassabb indítási időkre és frissítésekre, különösen nagyobb méretű projektjeinknél. A Vite által nyújtott azonnali modulfrissítés (HMR) csökkenti a fejlesztési ciklusokat, gyorsítja az iterációt és a tesztelést.

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

// Project showcase
#[
  #let title = [
    Projekt bemutatása
  ]

  #set page(
    header: align(right + horizon, title)
  )

  #align(center, text(17pt)[
    #heading(title)
  ])

  == UI kimenetek

  #align(center, [
    #figure(
      image("img/desktop.png", height: 35%, width: 90%, fit: "stretch"),
      numbering: none,
      caption: "Desktop felhasználói felület"
    )
  ])

  #align(center, [
    #figure(
      image("img/mobile.png", height: 50%, width: 40%, fit: "stretch"),
      numbering: none,
      caption: "Mobil felhasználói felület"
    )
  ])
]

#[
  #let title = [
    Projekt bemutatása
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Lighthouse teljesítmény
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

  A regisztráció eléréséhez látogassuk meg az oldalt. A főoldalon a jobb felső sarokban a Register szöveg megnyomása során elérjük a következő oldalt amit az alábbi képen láthatunk:

  #align(center, [#image("img/registerpage.png", height: 35%, width: 65%, fit: "stretch")])

  A regisztrációs oldalon az adataink kitöltésével tudunk beregisztrálni az oldalra:
  - Az email address résznél a saját egyénileg használt email fiókunkat kell megadni.
  - A username résznél egyedileg választott felhasználó nevünket adhatjuk meg amit az oldalon való bejelentkezés során fogunk használni a későbbiekben.
  - A password résznél egyedileg választott jelszavunkat adhatjuk meg, ami fontos hogy ne használjuk sehol máshol, és ne osszuk meg senkivel.

  #align(center, [#image("img/fillregisterpage.png", height: 35%, width: 65%, fit: "stretch")])

  Amint kitöltöttük az adatainkkal a regisztrációs oldalt, nyomjunk rá a *Continue* gombra.

  === Regisztráció megerősítése emailben

  Amint a *Continue* gombra rányomtunk, a következő oldalt fogja behozni nekünk:

  #align(center, [#image("img/registeremailverify.png", height: 35%, width: 65%, fit: "stretch")])

  Az oldalon a megadott email címünkre érkezett kóddal tudjuk megerősíteni a regisztrációnkat.

  A következő email-t fogjuk kapni a megadott email címünkre:

  #align(center, [#image("img/verifyemail.png", height: 31%, width: 100%, fit: "stretch")])

  Az emailre kapott kódot írjuk az Email code részbe majd nyomjunk rá a *Continue* gombra.

  Ezek után az oldal átirányít a bejelentkezés menüpontra, ahonnan már betudunk jelentkezni a létrehozott felhasználói fiókkal.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Bejelentkezés

  A bejelentkezés lehetősége az oldal főoldalán található a jobb felső sarokban, a regisztráció előtt. Kattintsunk a Sign in gombra, és a következő oldalon találjuk magunkat, ahol lehetőségünk van bejelentkezni az oldalra:

  #align(center, [#image("img/signinpage.png", height: 30%, width: 70%, fit: "stretch")])

  Az oldalon az Email address résznél adjuk meg a regisztrációnál használt email címünket, valamint a választott jelszavunkat. A Continue gomb segítségével tudunk bejelentkezni miután kitöltöttük az adatokat. Ha még nem regisztráltunk fiókot, kattintsunk a Register here szövegre.
  
  A sikeres bejelentkezést követően a felhasználó neve és az avatárja megjelenik a jobb felső sarokban. Erre kattintva könnyen és gyorsan hozzáférhetünk a fiókunkhoz és az ehhez kapcsolódó funkciókhoz az oldalon.

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

  Ha a felhasználó nevére kattintunk, további funkciókat érhetünk el:
  - Az első pontban megtekinthetjük a profilunk oldalát, ahol információkat tekinthetünk meg rólunk és beállíthatunk linkeket a profilunkhoz.
  - A második menüpontban különböző beállításokat tehetünk a felhasználói fiókkal kapcsolatban, melyek elérhetők a Settings menüpont alatt.
  - A harmadik menüpont segítségével pedig kijelentkezhetünk a felhasználói fiókból, amennyiben szükséges.

  Ezek a lehetőségek segítenek a felhasználónak teljes körűen kezelni és testre szabni az online jelenlétét és fiókját a platformon.

  #align(center, [#image("img/Profilebar.png", height: 20%, width: 40%, fit: "stretch")])
  
  === Profil

  #align(center, [#image("img/profilepage.png", height: 25%, width: 40%, fit: "stretch")])

  *Szintlépés*

  Minden vásárlás után pontokat kapsz, amelyek segítségével szintet léphetsz. Minél több pontot gyűjtesz, annál magasabb szintre léphetsz. A szintlépés előnyei közé tartozik a különféle kedvezmények, ajándékok és exkluzív tartalmak hozzáférése.
  
  Vásárolj termékeket vagy szolgáltatásokat az alkalmazásunkban a szokásos módon.
  Minél több vásárlást hajtasz végre, annál több pontot vagy "szintet" szerezhetsz.
  A vásárlások után ellenőrizd a profilodat, hogy lássad, elérted-e az új szintet, és milyen előnyökkel jár ez a szintlépés.

  *Közösségi kapcsolatok*

  Ahhoz, hogy a közösségi kapcsolatokat hozzáadhassuk a felhasználónkhoz, először kattintsunk a képen látható ceruza ikonra, majd ott a megfelelő mezők kitöltésével tudunk különböző külső közösségi fiókokat hozzáadni a felhasználó profiljához.

]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Beállítások

  #align(center, [#image("img/accountsettingspage.png", height: 20%, width: 110%, fit: "stretch")])

  Az oldal Settings menüpontja alatt két fontos cselekmény érhető el. Az első gomb segítségével lehetőségünk van véglegesen törölni a felhasználói fiókunkat. A második gombbal pedig lehetőségünk van beállítani fizetési adatainkat az oldalon, hogy későbbi vásárlásaink során automatikus és gyors fizetést biztosíthassunk.

  == Eladó profil

  #align(center, [#image("img/sellerdashboard.png", height: 20%, width: 110%, fit: "stretch")])

  A Seller Dashboard két egyszerű részre van bontva. Az első rész, melyet a Profile szekció képvisel, lehetővé teszi az eladó profil személre szabását, míg a második rész a Seller Offer, ahol az eladó termékeinek és ajánlatainak kezelése történik.

  === Profil rész

  A Profile szakasz magában foglalja az eladó teljes bemutatását, ahol testre szabott beállításokat végezhet a Profil menü ceruza ikonjára való kattintással. A szakaszban láthatjuk a profilképünket, a nevünket, valamint hogy hitelesített eladók vagyunk-e.

  === Ajánlatok rész

  A plusz gombra kattintva újabb árúcikk létrehozására van lehetőségünk. A jelenleg kínált termékek pedig egy áttekinthető listán jelennek meg, amely lehetőséget nyújt a könnyű navigációra és a kínálatban való eligazodásra a next és previous navigációs opciókkal.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Ajánlat létrehozása

  A Seller Dashboardon, az Offer részleg belül, a plusz jelre való kattintással érjük el a következő modális ablakot, melyben árucikkeinket eladásra bocsátani lehetőség nyílik.

  #align(center, [#image("img/addoffer.png", height: 30%, width: 60%, fit: "stretch")])

  - Először is, a Select a game legördülő menüjéből kiválasztjuk az eladásra szánt játékot.
  - Ezután, a Select a delivery type lehetőségében kiválasztjuk azt a szállítási típust, amely a vevő számára elérhetővé válik (például: Steam kulcs), biztosítva ezzel a tranzakció folyamatának személyre szabott és az elvárásoknak megfelelő kiszolgálását.
  - A végén, az utolsó sorban megadhatjuk az eladott árucikk árát, lehetővé téve a piaci versenyképesség fenntartását és az áralku számára megfelelő alapot.
  
  Ezt követően, végső lépésként, a Create offer gombra kattintva rögzíthetjük az ajánlatot.

  *Sikeres létrehozás*

  A sikeres játékajánlat létrehozását követően az oldal jobb alsó sarkában felbukkanó szöveges üzenettel találkozhatunk, mely az ajánlat sikeres rögzítését és az eljárás eredményes lezárását igazolja.

  #align(center, [#image("img/offercreated.png", height: 10%, width: 60%, fit: "stretch")])
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Stock hozzáadása

  A doboz ikonra kattintva elérhetünk két lehetőséget: add stock, amivel új készletet tudunk felvinni, valamint clear stock, amivel a már feltöltött készletet tudjuk törölni.

  #align(center, [#image("img/randomoffer.png", height: 5%, width: 100%, fit: "stretch")])

  Az add stock gombra kattintva egy modális ablak jelenik meg, ahol új készletet tudunk hozzáadni az ajánlathoz.

  #align(center, [#image("img/addstock.png", height: 30%, width: 60%, fit: "stretch")])

  Az ablakban találhatunk egy egyszerű beviteli mezőt, ahol minden sor egy új kulcsot reprezentál. Legalább egy kulcsot megadva, az add stock gombra kattintva azok azonnal hozzá lesznek adva az ajánlathoz.
  
  == Alapvető funkciók az oldalon
  
  === Keresés

  A kereső sávot, más néven Searchbart, a weboldal Search Games menüpontja alatt találhatjuk, ahol könnyedén elérhetővé válik a keresés funkció. Amikor ezt a menüpontot választjuk, az oldal egy új ablakot nyit meg, amely lehetőséget biztosít arra, hogy szabadon böngésszünk és kutassunk az elérhető játékkulcsok között.

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

  Miután megtaláltuk a keresett játékot és rákattintottunk, két különböző helyzettel találhatjuk szembe magunkat. Az első esetben, amennyiben a kiválasztott játékhoz van elérhető eladó kulcs, ezt azonnal láthatjuk. A második esetben pedig azt tapasztaljuk, hogy a megvásárolni kívánt játékhoz nincs elérhető kulcs eladó.

  Ez a megosztott élmény lehetővé teszi számunkra, hogy áttekintsük az eladásra kínált játékok aktuális állapotát és azok elérhetőségét. Így könnyedén dönthetünk arról, hogy melyik játékot választjuk, és szükség esetén azonnal megvásárolhatjuk vagy további lépéseket tehetünk annak érdekében, hogy megszerezzük a kívánt játékot.

  *Elérhető ajánlatok*

  #align(center, [#image("img/available offers.png", height: 15%, width: 100%, fit: "stretch")])

  *Ajánlatok hiánya*

  #align(center, [#image("img/nooffers.png", height: 16%, width: 100%, fit: "stretch")])

  *Vásárlás*

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

  == Admin felület

  Ahhoz, hogy hozzáférjünk az adminisztrációs felülethez, először is tekintsünk egy legördülő menüt a megadott képen. Ebben a menüben sötét kék betűszínnel kiemelve található az „admin” felirat. Fontos megjegyezni, hogy amennyiben nem rendelkezünk adminisztrátori jogosultsággal, ez a lehetőség sajnos nem lesz elérhető számunkra.

  Az adminisztrációs funkció egy magasabb szintű jogosultságot képvisel az oldalon, mely kizárólag az adminisztrátori jogosultsággal rendelkező felhasználóknak engedélyezett. Az adminisztrátorok különböző kulcsfontosságú beállításokat, kezelési feladatokat, valamint a platform szélesebb körű irányítását képesek ellátni. Ilyen lehetőségeik közé tartozik például a felhasználók kezelése, a tartalmak moderálása vagy akár a platform biztonságának felügyelete.
]

#[
#let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  *Instrukciós kép legördülő adminmenü eléréshez:*

   #align(center, [#image("img/dropdownadmin.png", height: 25%, width: 25%, fit: "stretch")])

  === Statisztika oldal 
  
  #align(center, [#image("img/staticpage.png", height: 30%, width: 100%, fit: "stretch")])

  Az oldalunk rendelkezik különböző statisztikai adatokkal, melyeket a felhasználók nemcsak megtekinthetnek, hanem hasznosíthatnak is. Amennyiben az oldalon valamelyik statisztikai fülre kattintunk, eljuthatunk az adott statisztika részleteihez és adataihoz. Ez a funkció különösen hasznos lehet mobil eszközökön, ahol a navigációs sáv nem mindig látható vagy könnyen hozzáférhető.

  Az oldalunk által nyújtott statisztikai adatok lehetővé teszik számunkra, hogy mélyebben megértsük az oldal teljesítményét, a felhasználói viselkedést és más fontos trendeket. Ezek az adatok segíthetnek nekünk abban, hogy jobban megértsük az oldalunkat használó közönség igényeit és szokásait, valamint segíthetnek abban is, hogy optimalizáljuk az oldalunkat és fejlesszük annak felhasználói élményét.

  - *Tags:* Az oldalon lévő "tags" számának megjelenítése.
  - *Games:* Az oldalon található játékok számának megjelenítése.
  - *Sellers:* Az oldalhoz kötött eladók számának megjelenítése.
  - *Offers:* Az oldalon található ajánlatok számának megjelenítése.
  - *Users:* Az oldalon regisztrált felhasználók számának megjelenítése.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Felhasználók oldal

  #align(center, [#image("img/Adminuserspage.png", height: 30%, width: 100%, fit: "stretch")])

  Az "users" oldalon, amelyhez adminisztrátori jogosultsággal rendelkezünk, kivételes lehetőséget kapunk a felhasználók részletes adatainak megtekintésére és kezelésére. Itt láthatjuk az egyes felhasználók email címét, nevét, regisztrációs dátumát és jogosultsági körét. Emellett az adminisztrátori funkciók is elérhetőek a három egyvonalban lévő pontra kattintva, melyek segítségével további műveleteket végezhetünk a felhasználókkal kapcsolatban.

  Ezek az adminisztrátori funkciók lehetővé teszik számunkra, hogy hatékonyan kezeljük és szabályozzuk a felhasználók profiljait. Ilyen funkciók közé tartozik például a sellerek hozzáadása vagy eltávolítása a felhasználó profiljából, valamint az azonosító másolása. Ezek a funkciók lehetővé teszik számunkra, hogy rugalmasan és gyorsan reagáljunk a felhasználók igényeire és a platform változó követelményeire.

  === Tagek oldal

  #align(center, [#image("img/Admintagspage.png", height: 30%, width: 100%, fit: "stretch")])
  
  Az "Tags" oldal egy különleges teret kínál számunkra, ahol a játékokhoz rendelt címkéket személyre szabhatjuk és kezelhetjük az adminisztrátori funkciók segítségével. Ez a helyszín lehetőséget biztosít számunkra, hogy finomhangoljuk a játékokhoz rendelt címkéket, megújítsuk azokat, és akár új címkéket is létrehozzunk az adott játékokhoz.
]

#[
  #let title = [
    Felhasználói dokumentáció
  ]

  #set page(
    header: align(right + horizon, title)
  )

  === Játékok oldal

  #align(center, [#image("img/Admingamespage.png", height: 25%, width: 90%, fit: "stretch")])

  Az "Games" oldal egy kulcsfontosságú része az adminisztrációs felületnek, ahol az adminisztrátorok a weboldalon elérhető játékokkal kapcsolatos funkciókat és adatokat kezelhetik. Ez az oldal lehetőséget kínál az egyes játékok részletes szerkesztésére és új játékok hozzáadására az adminisztrátori jogosultságok keretében.

  *A játékokat a következő adatokkal listázzuk:*

  - *Slug:* Ez egy ember által olvasható azonosító, amely egyedi azonosítót jelent a játékok számára.
  - *Name:* A játék neve, amely segít az azonosításban és a felhasználók számára való könnyebb azonosításban.
  - *Created at:* Ez a dátum jelzi, hogy mikor lett létrehozva az adott játék az oldalon.
  - *Active:* Ez a mező azt mutatja, hogy az adott játék aktív-e vagy sem a boltban. Ha aktív, akkor a felhasználók számára látható és megvásárolható.
  - *Featured:* Ez a jelző azt mutatja, hogy a játék kiemelt-e vagy sem az oldalon. A kiemelt játékok általában előnyt élveznek a promóciókban és a keresési eredményekben.

  #align(center, [#image("img/AdminCreateGames.png", height: 30%, width: 50%, fit: "stretch")])

  Amikor az oldalon a "plusz" gombra kattintunk, megjelenik a "create game" funkció, amely egy speciális modális ablakot hoz elő. Ebben a modális ablakban lehetőségünk van új játék létrehozására, ahol az előzőleg felsorolt adatokat tölthetjük ki. Emellett további funkcionalitások is elérhetőek, mint például tagek hozzáadása, leírás megadása és képek feltöltése.

  A "Create game" gomb megnyomásával lehetőségünk van az új játék hozzáadására az oldalhoz.
]