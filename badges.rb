#!/usr/bin/env ruby

require 'prawn'
ROOT = File.expand_path('..', __FILE__)
FONTS = "#{ROOT}/fonts"
IMAGES = "#{ROOT}/images"

pdf = Prawn::Document.new(:margin => [72, 18])

pdf.create_stamp('logo') do
  pdf.image "#{IMAGES}/mwrc-2015.png", width: 72 * 3, height: 72, at: [0, 0]
end

pdf.create_stamp('twitter') do
  pdf.image "#{IMAGES}/twitter.png", width: 12, height: 12, at: [0, 0]
end

pdf.create_stamp('github') do
  pdf.image "#{IMAGES}/github.png", width: 12, height: 12, at: [0, 0]
end

pdf.font_families.update(
  'Gotham' => { normal: "#{FONTS}/Gotham-Book.ttf" },
  'Tungsten' => { normal: "#{FONTS}/Tungsten-Medium.ttf" }
)

data = [
  {name: 'Mike Moore 1', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 2', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 3', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 4', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 5', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 6', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 7', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 8', twitter: 'blowmage', github: 'blowmage'},
  {name: 'Mike Moore 9', twitter: 'blowmage', github: 'blowmage'}
]

def render_badge(pdf, x, y, person)
  pdf.bounding_box(
    [x, y],
    width: 72 * 4, height: 72 * 3
  ) do
    pdf.stamp_at 'logo', [x + 72 * 0.5, y - (72 * 0.15)]
    pdf.font 'Tungsten'
    pdf.text_box(
      person[:name],
      size: 42, at: [72 * 0.4, 72 * 2],
      width: 72 * 3.2, height: 72 * 1.2, align: :center, valign: :center,
      overflow: :shrink_to_fit, disable_wrap_by_char: true
    )
    pdf.font 'Gotham'
    pdf.stamp_at 'twitter', [x + 72 * 1.12, y - (72 * 2.26)]
    pdf.text_box(
      person[:twitter],
      size: 12, at: [72 * 1.12 + 16, 72 * 0.74], width: 72 * 2, height: 72 * 0.31
    )
    pdf.stamp_at 'github', [x + 72 * 1.12, y - (72 * 2.56)]
    pdf.text_box(
      person[:github],
      size: 12, at: [72 * 1.12 + 16, 72 * 0.44], width: 72 * 2, height: 72 * 0.31
    )
  end
end

data.each_slice(6) do |people|
  y = pdf.bounds.height
  people.each_with_index do |person, index|
    x = index.odd? ? 72 * 4 : 0
    render_badge(pdf, x, y, person)
    y -= 72 * 3 if index.odd?
  end
  pdf.start_new_page
  y = pdf.bounds.height
  people.each_with_index do |person, index|
    x = index.even? ? 72 * 4 : 0
    render_badge(pdf, x, y, person)
    y -= 72 * 3 if index.odd?
  end
  pdf.start_new_page
end

pdf.render_file 'out.pdf'
