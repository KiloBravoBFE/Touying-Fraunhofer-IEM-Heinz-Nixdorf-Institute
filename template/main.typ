#import "../iem.typ": cards-slide, closing-slide, contents-slide, iem-theme, slide, subsection-slide, title-slide


// ------------------------------------------------------------
// Settings
// ------------------------------------------------------------

#show: iem-theme.with(
  footer: [{S}ecurify 26/27],

  fraunhofer-logo: image(
    "../assets/iem.svg",
    width: 100%,
  ),
  hni-logo: image(
    "../assets/hni.svg",
    width: 100%,
  ),

  fraunhofer-logo-white: image(
    "../assets/iem_white.svg",
    width: 100%,
  ),
  hni-logo-white: image(
    "../assets/hni_white.svg",
    width: 100%,
  ),
)


// ------------------------------------------------------------
// Title
// ------------------------------------------------------------

#title-slide(
  [{S}ecurify dev phase],
  subtitle: [Secure Software Engineering WS 26/27],
  author: [Eric Muster],
  photo: "assets/bg/hni.png",
)


// ------------------------------------------------------------
// Contents
// ------------------------------------------------------------

#contents-slide(
  title: [Contents],
  photo: "assets/bg/tube.png",
  items: (
    [Introduction],
    [Important terms],
    [Exercise sheets],
    [Questions],
  ),
)

// ------------------------------------------------------------
// Chapter
// ------------------------------------------------------------

#subsection-slide(
  [IMPORTANT TERMS],
  number: 1,
  photo: "assets/bg/tube.png",
)

// ------------------------------------------------------------
// Regular content
// ------------------------------------------------------------

#slide(
  title: [Exercise Sheets and Sessions],
  subtitle: [Course organisation],
)[
  - There will be five exercise sheets to work on at home.

  - Biweekly exercise sessions will discuss the solutions.

  - The schedule and further details are available online.
]

// ------------------------------------------------------------
// Three cards
// ------------------------------------------------------------

#cards-slide(
  title: [Our Approach],
  subtitle: [Three areas of work],
  cards: (
    (
      photo: "assets/bg/cards1.png",
      number: [01],
      description: [Understand the problem and its context.],
    ),
    (
      photo: "assets/bg/cards2.png",
      number: [02],
      description: [Develop and evaluate a solution.],
    ),
    (
      photo: "assets/bg/cards3.png",
      number: [03],
      description: [Apply the results in practice.],
    ),
  ),
)


// ------------------------------------------------------------
// Closing
// ------------------------------------------------------------

#closing-slide[
  Thank you for your attention
]
