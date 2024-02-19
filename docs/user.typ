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
  #align(center + horizon, text(25pt)[*Vizsgaremek*])
  #pagebreak()
]

// Outline page
#[
  #align(center + horizon, text(25pt)[*Tartalom*])

  #show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }

  #outline(indent: auto, title: "")
  #pagebreak()
]

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
  #lorem(300)
]

#[
  #let title = [
    Visual Studio, Visual Studio Code
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Visual Studio

  #lorem(200)

  == Visual Studio Code

  #lorem(200)
]

#[
  #let title = [
    PostgreSQL, MySQL
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == PostgreSQL
  
  #lorem(200)

  == MySQL

  #lorem(200)
]

#[
  #let title = [
    .NET, ASP.NET, ASP.NET Core
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == .NET
  
  #lorem(200)

  == ASP.NET, ASP.NET Core

  #lorem(200)
]

#[
  #let title = [
    Vite, TypeScript, React, Tailwind CSS
  ]

  #set page(
    header: align(right + horizon, title)
  )

  == Vite, TypeScript
  
  #lorem(200)

  == React, Tailwind CSS

  #lorem(200)
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

  == Bevezetés
  #lorem(300)
]

#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()