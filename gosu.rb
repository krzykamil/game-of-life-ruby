require 'gosu'
require_relative 'gol.rb'

class GameOfLifeWindow < Gosu::Window

  def initialize(height=1800, width=900)

    # Basics
    @height = height
    @width = width
    super height, width, false
    self.caption = "Sven's Game of Life"

    # Colors
    @background = Gosu::Color.new(0xffdedede)
    @alive = Gosu::Color.new(0xff121212)
    @dead = Gosu::Color.new(0xffededed)

    # Game world
    @rows = height/10
    @cols = width/10
    @world = World.new(@cols, @rows) # Note: col is 1st
    @game = Game.new(@world)
    @row_height = height/@rows
    @col_width = width/@cols
    @game.world.randomly_populate

    @generation = 0
  end

  def update
    @game.tick!
    @generation += 1
    puts "Generation No: #{@generation}"
  end

  def draw
    draw_background
    @game.world.cells.each do |cell|
      if cell.alive?
        draw_quad(cell.x * @col_width, cell.y * @row_height, @alive,
                  cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @alive,
                  cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @alive,
                  cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @alive)
      else
        draw_quad(cell.x * @col_width, cell.y * @row_height, @dead,
                  cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @dead,
                  cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @dead,
                  cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @dead)
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::KbSpace
      @game.world.randomly_populate
    when Gosu::KbEscape
      close
    end
  end

  def needs_cursor?
    true
  end

  def draw_background
    draw_quad(0, 0, @background,
              width, 0, @background,
              width, height, @background,
              0, height, @background)
  end

end

GameOfLifeWindow.new.show
