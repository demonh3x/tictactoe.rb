class Game
  def initialize(state, ui, players)
    @state = state
    @ui = ui
    @turns = players.cycle
  end

  def finished?
    state.is_finished?
  end

  def start
    update_ui
  end

  def step
    give_turn
    update_ui
  end

  private
  
  attr_accessor :state, :ui, :turns

  def give_turn
    player = turns.next
    location = player.ask_for_location(state)
    mark = player.mark

    self.state = state.make_move(location, mark)
  end

  def update_ui
    ui.update(state)
  end
end
