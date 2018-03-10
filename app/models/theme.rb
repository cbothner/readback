# frozen_string_literal: true

Color = Struct.new :bright, :dark, :contrast do
  {
    black: ['53, 53, 53', '38, 38, 38', '237, 241, 242'],
    blue: ['80, 102, 161', '57, 77, 130', '237, 241, 242'],
    brown: ['94, 69, 52', '79, 58, 43', '237, 241, 242'],
    coffee: ['163, 134, 113', '143, 114, 94', '237, 241, 242'],
    forest_green: ['52, 94, 65', '44, 79, 53', '237, 241, 242'],
    gray: ['149, 165, 166', '126, 139, 140', '237, 241, 242'],
    green: ['47, 204, 112', '38, 173, 95', '43, 43, 43'],
    lime: ['166, 199, 60', '143, 176, 33', '43, 43, 43'],
    magenta: ['155, 89, 181', '142, 68, 173', '237, 241, 242'],
    maroon: ['120, 48, 42', '102, 37, 33', '237, 241, 242'],
    mint: ['26, 189, 156', '22, 161, 133', '43, 43, 43'],
    navy_blue: ['52, 73, 94', '43, 61, 79', '237, 241, 242'],
    orange: ['230, 125, 34', '212, 85, 0', '43, 43, 43'],
    pink: ['245, 125, 197', '212, 91, 157', '43, 43, 43'],
    plum: ['94, 52, 94', '79, 43, 79', '237, 241, 242'],
    powder_blue: ['184, 202, 242', '154, 172, 214', '43, 43, 43'],
    purple: ['116, 94, 196', '92, 72, 163', '237, 241, 242'],
    red: ['232, 78, 60', '191, 57, 42', '237, 241, 242'],
    sand: ['240, 222, 180', '214, 195, 150', '43, 43, 43'],
    sky_blue: ['53, 153, 219', '41, 128, 186', '237, 241, 242'],
    teal: ['59, 112, 130', '53, 98, 115', '237, 241, 242'],
    watermelon: ['240, 113, 121', '217, 85, 89', '237, 241, 242'],
    white: ['237, 241, 242', '189, 195, 199', '43, 43, 43'],
    yellow: ['255, 205, 3', '255, 170, 0', '43, 43, 43']
  }.map do |name, params|
    define_singleton_method name do
      new(*params)
    end
  end
end

Theme = Struct.new(:primary, :accent) do
  def to_s
    primary.bright
  end

  {
    black:  :pink,
    blue:  :orange,
    brown:  :lime,
    coffee:  :forest_green,
    forest_green: :plum,
    gray: :watermelon,
    green: :powder_blue,
    lime:  :watermelon,
    magenta: :yellow,
    mint: :purple,
    navy_blue: :pink,
    orange: :red,
    pink: :sky_blue,
    plum: :mint,
    powder_blue: :white,
    purple:  :orange,
    red: :blue,
    sky_blue:  :yellow,
    teal: :watermelon,
    watermelon: :brown,
    white: :purple,
    yellow:  :plum
  }.map do |primary, accent|
    define_singleton_method primary do
      new Color.send(primary), Color.send(accent)
    end
  end
end
