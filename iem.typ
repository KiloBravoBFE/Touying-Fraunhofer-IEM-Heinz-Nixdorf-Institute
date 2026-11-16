#import "@preview/touying:0.8.0": *

// ============================================================
// Colours
// ============================================================

#let iem-blue = rgb("#003a80")
#let iem-blue-transparent = rgb("#003a80bf") // last two digits: opacity; from 00 to ff.
#let iem-green = rgb("#179c7d")
#let iem-green-transparent = rgb("#179c7dbf") // bf is approximately 75% opacity.
#let iem-dark = rgb("#404040")

// Opaque gradient, the regular non-img version
#let iem-gradient = gradient.linear(
  iem-blue,
  iem-green,
  angle: 50deg,
)

// Semi-transparent gradient for img
#let iem-photo-gradient = gradient.linear(
  iem-blue-transparent,
  iem-green-transparent,
  angle: 50deg,
)


// ============================================================
// Logos and footer
// ============================================================

#let logo-box(logo, width) = {
  if logo != none {
    block(width: width, logo)
  }
}

#let logo-pair(hni, fraunhofer) = {
  grid(
    columns: (95pt, 90pt),
    column-gutter: 12pt,
    align: (left + bottom, right + bottom),

    move(
      dy: 3pt,
      dx: -40pt,
      logo-box(hni, 104pt),
    ),

    move(
      dy: 9pt,
      dx: -10pt,
      logo-box(fraunhofer, 100pt),
    ),
  )
}

#let footer-line(self, hni: none, fraunhofer: none) = {
  let footer-text = {
    set text(size: 12pt, fill: iem-dark)
    h(13pt)
    context utils.slide-counter.display()
    h(10pt)
    text(fill: rgb("#888888"))[|]
    h(10pt)

    if self.store.footer != none {
      utils.call-or-display(self, self.store.footer)
    }
  }

  // Chapter slides
  if hni == none and fraunhofer == none {
    block(width: 100%, footer-text)
  } else {
    block(
      width: 100%,
      grid(
        columns: (1fr, 197pt),
        column-gutter: 12pt,
        align: (left + bottom, right + bottom),

        footer-text, logo-pair(hni, fraunhofer),
      ),
    )
  }
}


// ============================================================
// Photo and gradient panel
// ============================================================
//
// photo:
//   optional img path string (relative to THIS file!)
//
// overlay:
//   The gradient drawn over the photo Set to none if you want to
//
// body:
//   Foreground content, drawn on top of the image and gradient

#let photo-panel(
  photo: none,
  overlay: iem-photo-gradient,
  body: [],
) = {
  block(
    width: 100%,
    height: 100%,
    {
      if photo != none {
        place(
          top + left,
          image(
            photo,
            width: 100%,
            height: 100%,
            fit: "cover",
          ),
        )

        if overlay != none {
          place(
            top + left,
            rect(
              width: 100%,
              height: 100%,
              fill: overlay,
              stroke: none,
            ),
          )
        }
        // no img
      } else {
        place(
          top + left,
          rect(
            width: 100%,
            height: 100%,
            fill: iem-gradient,
            stroke: none,
          ),
        )
      }

      // content on top of it
      place(
        top + left,
        block(
          width: 100%,
          height: 100%,
          body,
        ),
      )
    },
  )
}


// ============================================================
// Contents slide
// ============================================================
//
// #contents-slide(
//   title: [GLIEDERUNG],
//   photo: "tube.png",
//   items: (
//     [First chapter],
//     [Second chapter],
//     [Third chapter],
//   ),
// )

#let contents-slide(
  title: [GLIEDERUNG],
  items: (),
  photo: none,
  overlay: iem-photo-gradient,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = grid(
    columns: (2fr, 1fr),
    rows: (100%,),

    // heading, numbered list and footer
    rect(
      width: 100%,
      height: 100%,
      fill: white,
      stroke: none,
      inset: (
        left: 70pt,
        right: 32pt,
        top: 25pt,
        bottom: 16pt,
      ),
      {
        align(
          left + horizon,
          block(
            width: 100%,
            {
              block(
                text(
                  size: 40pt,
                  weight: "bold",
                  fill: iem-dark,
                  title,
                ),
              )

              v(15pt)

              set text(size: 20pt, fill: iem-dark)
              set enum(spacing: 0.55em)

              enum(..items)
            },
          ),
        )

        place(
          bottom + left,
          dx: -38pt,
          footer-line(self),
        )
      },
    ),

    // right panel
    photo-panel(
      photo: photo,
      overlay: overlay,
      body: block(
        width: 100%,
        height: 100%,
        inset: (
          left: 16pt,
          right: 24pt,
          top: 25pt,
          bottom: 16pt,
        ),
        {
          place(
            bottom + right,
            logo-pair(
              self.store.hni-logo-white,
              self.store.fraunhofer-logo-white,
            ),
          )
        },
      ),
    ),
  )

  touying-slide(self: self, body)
})




// ============================================================
// Three-image card slide
// ============================================================
//
// Each card is a dictionary containing:
//   photo:       image path, or none
//   number:      content, e.g. [01]
//   description: content
//
// #cards-slide(
//   title: [Title],
//   subtitle: [Subtitle],
//   cards: (
//     (photo: "side1_13.png", number: [01], description: [First]),
//     (photo: "side2_13.png", number: [02], description: [Second]),
//     (photo: "side3_13.png", number: [03], description: [Third]),
//   ),
// )

#let cards-slide(
  title: none,
  subtitle: none,
  cards: (),
  overlay: iem-photo-gradient,
) = touying-slide-wrapper(self => {
  assert(
    cards.len() == 3,
    message: "cards-slide expects exactly three cards",
  )

  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  // The grid is filled row by row: first the three images,
  // then the three text cards.
  let image-cells = cards.map(card => {
    photo-panel(
      photo: card.at("photo", default: none),
      overlay: overlay,
    )
  })

  let text-cells = cards.map(card => {
    rect(
      width: 100%,
      height: 100%,
      fill: white,
      stroke: 0.5pt + rgb("#c8c8c8"),
      inset: (
        left: 28pt,
        right: 22pt,
        top: 18pt,
        bottom: 12pt,
      ),
      {
        block(
          text(
            size: 25pt,
            weight: "bold",
            fill: iem-dark,
            card.at("number", default: []),
          ),
        )

        v(8pt)

        block(
          text(
            size: 16pt,
            fill: iem-dark,
            card.at("description", default: []),
          ),
        )
      },
    )
  })

  let body = grid(
    columns: (1fr,),
    rows: (22%, 68%, 10%),

    block(
      width: 100%,
      height: 100%,
      inset: (
        left: 32pt,
        right: 32pt,
        top: 25pt,
        bottom: 5pt,
      ),
      {
        if title != none {
          block(
            text(
              size: 21pt,
              weight: "bold",
              fill: iem-dark,
              title,
            ),
          )
        }

        if subtitle != none {
          v(3pt)
          block(
            text(
              size: 18pt,
              weight: "bold",
              fill: iem-green,
              subtitle,
            ),
          )
        }
      },
    ),

    // Full-width img and description grid
    block(
      width: 100%,
      height: 100%,
      grid(
        columns: (1fr, 1fr, 1fr),
        rows: (50%, 50%),
        ..(image-cells + text-cells),
      ),
    ),

    block(
      width: 100%,
      height: 100%,
      {
        place(
          bottom + left,
          dy: -16pt,
          block(
            width: 100%,
            inset: (left: 32pt, right: 32pt),
            footer-line(
              self,
              hni: self.store.hni-logo,
              fraunhofer: self.store.fraunhofer-logo,
            ),
          ),
        )
      },
    ),
  )

  touying-slide(self: self, body)
})


// ============================================================
// Normal content slide
// ============================================================
//
// #slide(title: [Title], subtitle: [Subtitle])[
//   Slide content
// ]

#let slide(
  title: none,
  subtitle: none,
  ..args,
  content,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = block(
    width: 100%,
    height: 100%,
    inset: (
      left: 32pt,
      right: 32pt,
      top: 25pt,
      bottom: 16pt,
    ),
    {
      pad(bottom: 45pt)[
        #if title != none {
          block(
            width: 100%,
            text(
              size: 21pt,
              weight: "bold",
              fill: iem-dark,
              title,
            ),
          )
        }

        #if subtitle != none {
          v(3pt)
          block(
            width: 100%,
            text(
              size: 18pt,
              weight: "bold",
              fill: iem-green,
              subtitle,
            ),
          )
        }

        #if title != none or subtitle != none {
          v(28pt)
        }

        #content
      ]

      place(
        bottom + left,
        footer-line(
          self,
          hni: self.store.hni-logo,
          fraunhofer: self.store.fraunhofer-logo,
        ),
      )
    },
  )

  touying-slide(self: self, ..args, body)
})


// ============================================================
// Title slide
// ============================================================
//
// #title-slide(
//   [PRESENTATION TITLE],
//   subtitle: [Subtitle],
//   author: [Name],
//   date: [Paderborn | Date],
//   photo: "page1.jpg",
// )

#let title-slide(
  title,
  subtitle: none,
  author: none,
  date: none,
  photo: none,
  overlay: iem-photo-gradient,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = grid(
    columns: (2fr, 1fr),
    rows: (100%,),

    // img & title
    photo-panel(
      photo: photo,
      overlay: overlay,
      body: block(
        width: 100%,
        height: 100%,
        inset: (
          left: 32pt,
          right: 32pt,
          top: 25pt,
          bottom: 25pt,
        ),
        align(right + horizon, {
          set align(right)
          set text(fill: white)

          block(
            width: 100%,
            text(
              size: 40pt,
              weight: "bold",
              title,
            ),
          )

          if subtitle != none {
            v(14pt)
            block(text(size: 24pt, subtitle))
          }

          if author != none {
            v(35pt)
            block(text(size: 24pt, author))
          }

          if date != none {
            v(8pt)
            block(text(size: 24pt, date))
          }
        }),
      ),
    ),

    // right bar
    rect(
      width: 100%,
      height: 100%,
      fill: white,
      stroke: none,
      inset: 32pt,
      align(center + horizon, {
        set align(center)

        move(
          dy: 6pt,
          dx: -10pt,
          logo-box(self.store.fraunhofer-logo, 185pt),
        )
        v(35pt)
        move(
          dy: -2pt,
          dx: -10pt,
          logo-box(self.store.hni-logo, 185pt),
        )
      }),
    ),
  )

  touying-slide(self: self, body)
})


// ============================================================
// Chapter / subsection title slide
// ============================================================
//
// #subsection-slide(
//   [IMPORTANT TERMS],
//   number: 1,
//   photo: "tube.png",
// )
//
// I hate automatic numbering in these things, so just deal with
// having to type it out pls :P

#let subsection-slide(
  title,
  number: none,
  photo: none,
  overlay: iem-photo-gradient,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = grid(
    columns: (2fr, 1fr),
    rows: (100%,),

    // title
    rect(
      width: 100%,
      height: 100%,
      fill: white,
      stroke: none,
      inset: (
        left: 32pt,
        right: 32pt,
        top: 25pt,
        bottom: 16pt,
      ),
      {
        align(
          right + horizon,
          block(
            width: 100%,
            align(
              right,
              text(
                size: 32pt,
                weight: "bold",
                fill: iem-dark,
                title,
              ),
            ),
          ),
        )

        place(
          bottom + left,
          footer-line(self),
        )
      },
    ),

    // right bar
    photo-panel(
      photo: photo,
      overlay: overlay,
      body: block(
        width: 100%,
        height: 100%,
        inset: (
          left: 16pt,
          right: 24pt,
          top: 25pt,
          bottom: 16pt,
        ),
        {
          if number != none {
            move(
              dy: 190pt,
              dx: 31pt,
              text(
                size: 60pt,
                weight: "bold",
                fill: white,
                str(number),
              ),
            )
          }

          place(
            bottom + right,
            logo-pair(
              self.store.hni-logo-white,
              self.store.fraunhofer-logo-white,
            ),
          )
        },
      ),
    ),
  )

  touying-slide(self: self, body)
})


// ============================================================
// Closing slide
// ============================================================
//
// #closing-slide[
//   Vielen Dank für Ihre Aufmerksamkeit
// ]

#let closing-slide(
  message,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = rect(
    width: 100%,
    height: 100%,
    fill: iem-gradient,
    stroke: none,
    inset: (
      left: 32pt,
      right: 32pt,
      top: 25pt,
      bottom: 16pt,
    ),
    {
      align(
        center + horizon,
        block(
          width: 75%,
          align(
            center,
            text(
              size: 38pt,
              weight: "bold",
              fill: white,
              message,
            ),
          ),
        ),
      )

      place(
        bottom + right,
        logo-pair(
          self.store.hni-logo-white,
          self.store.fraunhofer-logo-white,
        ),
      )
    },
  )

  touying-slide(self: self, body)
})


// ============================================================
// Theme
// ============================================================

#let iem-theme(
  footer: none,
  hni-logo: none,
  fraunhofer-logo: none,
  hni-logo-white: none,
  fraunhofer-logo-white: none,
  font: "Arial",
  lang: "en",
  ..args,
  body,
) = {
  set text(
    font: font,
    size: 16pt,
    fill: iem-dark,
    lang: lang,
  )

  set par(leading: 0.7em)
  set list(marker: [▪], spacing: 1.1em)

  show: touying-slides.with(
    config-page(
      paper: "presentation-16-9",
      margin: 0pt,
    ),

    config-common(
      slide-fn: slide,
    ),

    config-store(
      footer: footer,
      hni-logo: hni-logo,
      fraunhofer-logo: fraunhofer-logo,
      hni-logo-white: hni-logo-white,
      fraunhofer-logo-white: fraunhofer-logo-white,
    ),

    ..args,
  )

  body
}
