require 'Qt'
require 'tictactoe/game'
require 'uis/gui/menu_window'
require 'uis/gui/main_window'

module UIs
  module Gui
    class Runner
      attr_reader :menu, :games

      def initialize()
        @running = false
        @app = Qt::Application.new(ARGV)
        @games = []
        @menu = UIs::Gui::MenuWindow.new(lambda{|options|
          ttt = Tictactoe::Game.new
          ttt.set_board_size(options[:board])
          ttt.set_player_x(options[:x])
          ttt.set_player_o(options[:o])
          game = UIs::Gui::MainWindow.new(ttt, options[:board])
          @games.push(game)
          game.show if @running
        })
      end

      def run
        @running = true
        @menu.show
        @games.each do |game|
          game.show
        end
        @app.exec
      end
    end
  end
end
