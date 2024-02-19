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
  #set text(13pt, weight: "regular")
  #block(smallcaps(it.body))
]

#show heading.where(
  level: 1
): it => [
  #set text(17pt, weight: "bold")
  #block(it.body)
]

// Title page
#[
  #align(center + horizon, text(25pt)[*Title*])
]

#pagebreak()

// Outline page
#[
  #align(center + horizon, text(25pt)[*Outline*])

  #show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }

  #outline(indent: auto)
]

#pagebreak()

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

  == Introduction
  #lorem(300)

  == Related Work
  #lorem(200)
]

#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()
#pagebreak()

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

  == Introduction
  #lorem(300)

  == Related Work
  #lorem(200)
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