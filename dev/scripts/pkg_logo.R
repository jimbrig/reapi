
#  ------------------------------------------------------------------------
#
# Title : Package Logo
#    By : Jimmy Briggs
#  Date : 2026-07-11
#
#  ------------------------------------------------------------------------

man_figures_path <- file.path(this.path::this.proj(), "man/figures")
if (!dir.exists(man_figures_path)) dir.create(man_figures_path)

# create composite logo -------------------------------------------------------------------------------------------

# TODO: add code here for the process of taking the original SVG image,
# creating a PNG, removing its background, etc.

# setup hex logo --------------------------------------------------------------------------------------------------

hex_img <- "man/figures/reapi-logo-color.png"
sysfonts::font_add_google("Ubuntu", "ubuntu")
showtext::showtext_auto()

# svg ---------------------------------------------------------------------

hexSticker::sticker(
  filename = "man/figures/hex-reapi.svg",
  # package name
  package = "reapi",
  p_x = 1,
  p_y = 1.4,
  p_color = "white",
  p_family = "ubuntu",
  p_fontface = "plain",
  p_size = 6,
  # image
  subplot = hex_img,
  s_x = 1,
  s_y = 1,
  s_width = 0.6,
  s_height = 1.2,
  asp = 1,
  dpi = 800,
  # hexagon
  h_size = 1.2,
  h_fill = monochromeR::rgb_to_hex(c(25, 25, 25)),
  h_color = monochromeR::rgb_to_hex(c(73, 41, 159)),
  # url
  url = "github.com/jimbrig/reapi",
  u_x = 1,
  u_y = 0.08,
  u_color = "cyan",
  u_family = "ubuntu",
  u_size = 1.2,
  u_angle = 30
)

# png ---------------------------------------------------------------------

# Warning: Using ragg device as default. Ignoring `type` and `antialias` arguments
# messes up the URL display for whatever reason.

# using my custom man/figures/entratar.hex.png image i made via hexmak application
# instead...

# hexSticker::sticker(
#   filename = "man/figures/hex-reapi.png",
#   # package name
#   package = "reapi",
#   p_x = 1,
#   p_y = 1.4,
#   p_color = "white",
#   p_family = "ubuntu",
#   p_fontface = "plain",
#   p_size = 6,
#   # image
#   subplot = hex_img,
#   s_x = 1,
#   s_y = 1,
#   s_width = 0.6,
#   s_height = 1.2,
#   asp = 1,
#   dpi = 800,
#   # hexagon
#   h_size = 1.2,
#   h_fill = monochromeR::rgb_to_hex(c(25, 25, 25)),
#   h_color = monochromeR::rgb_to_hex(c(73, 41, 159)),
#   # url
#   url = "github.com/jimbrig/reapi",
#   u_x = 1,
#   u_y = 0.08,
#   u_color = "cyan",
#   u_family = "ubuntu",
#   u_size = 1.2,
#   u_angle = 30
# )

# set package logo ------------------------------------------------------------------------------------------------

usethis::use_logo("man/figures/hex-reapi.png")
