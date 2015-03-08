#!/usr/bin/env ruby

require 'prawn'
require 'csv'

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

class Numeric

  def inches
    self * 72
  end
  alias :inch :inches

end

def render_badge(pdf, x, y, person)
  pdf.bounding_box(
    [x, y],
    width: 4.inches, height: 3.inches
  ) do
    pdf.stamp_at 'logo', [x + 0.5.inches, y - 0.15.inches]
    pdf.font 'Tungsten'
    pdf.text_box(
      person['name'],
      size: 42, at: [0.4.inches, 2.inches],
      width: 3.2.inches, height: 1.2.inches, align: :center, valign: :center,
      overflow: :shrink_to_fit, disable_wrap_by_char: true
    )
    pdf.font 'Gotham'
    width = [person['twitter'], person['github']].map {
      |v| pdf.width_of(v.to_s)
    }.max
    start_at = 2.inches - (width.to_f / 2) + 8
    if person['twitter']
      pdf.stamp_at 'twitter', [x + start_at - 16, y - 2.26.inches]
      pdf.text_box(
        person['twitter'],
        size: 12, at: [start_at, 0.74.inches],
        width: 2.inches, height: 0.31.inches
      )
    end
    if person['github']
      pdf.stamp_at 'github', [x + start_at - 16, y - (72 * 2.56)]
      pdf.text_box(
        person['github'],
        size: 12, at: [start_at, 0.44.inches],
        width: 72 * 2, height: 0.31.inches
      )
    end
  end
end

data = CSV.read(ARGV.first, headers: true)
data.each_slice(6) do |people|
  y = pdf.bounds.height
  people.each_with_index do |person, index|
    x = index.odd? ? 4.inches : 0
    render_badge(pdf, x, y, person)
    y -= 3.inches if index.odd?
  end
  pdf.start_new_page
  y = pdf.bounds.height
  people.each_with_index do |person, index|
    x = index.even? ? 4.inches : 0
    render_badge(pdf, x, y, person)
    y -= 3.inches if index.odd?
  end
  pdf.start_new_page
end

pdf.render_file 'badges.pdf'
