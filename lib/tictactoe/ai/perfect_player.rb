require 'tictactoe/ai/ab_minimax'
require 'tictactoe/ai/ab_negamax'

module Tictactoe
  module Ai
    class PerfectPlayer
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0
      SCORE_FOR_UNKNOWN_FUTURE = -1

      class Node
        def initialize(state, me, opponent, current_player, transition=nil)
          @state = state
          @me = me
          @opponent = opponent
          @current_player = current_player
          @transition = transition
        end
        attr_reader :state, :me, :opponent, :current_player, :transition

        def is_leaf?
          state.when_finished{true} || false
        end

        def childs
          state.available_moves.lazy.map do |transition|
            next_player = current_player == me ? opponent : me
            next_state = state.make_move transition, current_player
            Node.new(next_state, me, opponent, next_player, transition)
          end
        end

        def score 
          depth = state.available_moves.length + 1
          base_score * depth
        end

        def base_score
          state.when_finished do |winner|
            case winner
            when me
              MAXIMUM_SCORE
            when nil
              NEUTRAL_SCORE
            else
              MINIMUM_SCORE
            end
          end
        end

        def debug_print
          state.layout.each_slice(3) do |marks|
            puts marks.to_s
          end
          if is_leaf?
            puts "Score: " + score.to_s
          else
            puts "Intermediate node"
            childs.each {|c| c.debug_print}
          end
        end
      end

      def initialize(mark, opponents_mark, chooser)
        @mark = mark
        @opponents_mark = opponents_mark
        @chooser = chooser
      end

      attr_accessor :mark, :opponents_mark, :state

      def is_ready_to_move?
        true
      end

      def update(state)
        self.state = state
      end

      def play
        options = find_best_locations(state).map(&:state)
        @chooser.choose_one(options)
      end

      def play_location
        options = find_best_locations(state).map(&:transition)
        @chooser.choose_one(options)
      end

      def desired_moves
        find_best_locations(state).map(&:transition)
      end

      def find_best_locations(state)
        depth = 200

        ab_minimax = ABMinimax.new(-8, SCORE_FOR_UNKNOWN_FUTURE, depth) 

        root = Node.new(state, mark, opponents_mark, mark)
        locs = ab_minimax.evaluate(root)
        #root.debug_print
        locs
      end

      def dynamic_depth_for(state)
        played_moves = state.board.locations.length - state.available_moves.length

        if state.board.locations.length == 16
          depth = [7, played_moves].min
        else
          played_moves += 4
          depth = [5, played_moves].min
        end

        depth
      end
    end
  end
end
