require 'spec_helper'
require 'core/game'
require 'uis/cli'
require 'core/state'
require 'boards/four_by_four_board'
require 'boards/three_by_three_board'
require 'players/ai/perfect_player'
require 'players/ai/random_chooser'

RSpec.describe "Regression" do
  class UI
    attr_accessor :state

    def update(state)
      @state = state
    end
  end

  class RepeteableRandom
    attr_accessor :sequence, :progress

    def initialize(sequence = 20.times.map{Random.new.rand})
      @sequence = sequence
      @progress = sequence.cycle
    end

    def rand
      progress.next
    end

    def print
      puts "RepeteableRandom sequence: #{sequence.to_s}"
    end
  end

  def player(mark, opponent, random)
    Players::AI::PerfectPlayer.new(mark, opponent, Players::AI::RandomChooser.new(random))
  end

  def game_winner(board, random)
    ui = UI.new()
    game = Core::Game.new(
      Core::State.new(board),
      ui,
      [player(:x, :o, random), player(:o, :x, random)] 
    )

    game.start
    game.step until game.finished?

    ui.state.when_finished {|w| w}
  end

  describe "properties", :properties => true, :slow => true, :very_slow => true, :eternal => true do
    100.times do |n|
      it 'two perfect players in a 4x4 board ends up in a draw' do
        random = RepeteableRandom.new

        random.print
        puts n

        expect(game_winner Boards::FourByFourBoard.new, random).to eq(nil)
      end
    end

    100.times do |n|
      it 'two perfect players in a 3x3 board ends up in a draw' do
        random = RepeteableRandom.new

        random.print
        puts n

        expect(game_winner Boards::ThreeByThreeBoard.new, random).to eq(nil)
      end
    end
  end

  describe "regression", :regression => true, :slow => true, :very_slow => true do
    it '4x4 failure with depth 4' do
      sequence = [0.6626694797262954, 0.30448981659546004, 0.26798910592351544, 0.2830459900271195, 0.8895551951203527, 0.9046657862565063, 0.7899802463007816, 0.9098809266633705, 0.5677509599820714, 0.18716424973282353, 0.6105498878101738, 0.2681744677257635, 0.30826022341252124, 0.053929729073694754, 0.7765776002726397, 0.21077253937369878, 0.8753238832455099, 0.9254492923943836, 0.29696052495963243, 0.10534603754755134]
      expect(game_winner Boards::FourByFourBoard.new, RepeteableRandom.new(sequence)).to eq(nil)
    end

    it '4x4 failure with depth 4' do
      sequence = [0.1752952614642579, 0.8821241018038767, 0.6794926188368996, 0.8518302762222564, 0.4458811493973551, 0.9306345357423046, 0.3123799482994526, 0.5924524099570939, 0.6450816940352238, 0.8825832762954303, 0.23750013882693732, 0.12379845558667857, 0.7600372531198462, 0.9208682981404592, 0.4524751171155964, 0.31049852102768605, 0.7718096983015857, 0.6281565115385799, 0.9986801091827466, 0.18577634176797098]
      expect(game_winner Boards::FourByFourBoard.new, RepeteableRandom.new(sequence)).to eq(nil)
    end
    
    it '4x4 failure with depth 6' do
      sequence = [0.6137695984061624, 0.2695201125662491, 0.0008415175788497598, 0.832189486355373, 0.6430165225443919, 0.8156207919820028, 0.09507654190749693, 0.8769632565382544, 0.05710300982358729, 0.2448707731542331, 0.8227686892057651, 0.1670967918329198, 0.14015244123427695, 0.5902007740200433, 0.1892333599454875, 0.16358163954350124, 0.8366990526943789, 0.3834904620942655, 0.6036916112731134, 0.35463854154420804]
      expect(game_winner Boards::FourByFourBoard.new, RepeteableRandom.new(sequence)).to eq(nil)
    end

    it '3x3 failure with depth 4' do
      sequence = [0.26761252406241565, 0.3290653539136804, 0.2922656712698549, 0.6264650506684584, 0.8348217536107002, 0.6663705177073628, 0.4028423873660856, 0.8250949303519487, 0.2619108550896686, 0.9881311048809777, 0.17014068693848805, 0.9661804312253627, 0.8518758632715853, 0.4047533345563624, 0.8064386913142052, 0.8619449038153968, 0.7895923865428888, 0.19974944649456394, 0.3203368624001046, 0.08129744891781843]
      expect(game_winner Boards::ThreeByThreeBoard.new, RepeteableRandom.new(sequence)).to eq(nil)
    end
  end
end
