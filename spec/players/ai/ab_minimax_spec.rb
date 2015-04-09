require 'players/ai/ab_minimax'

RSpec.describe ABMinimax do
  def strategy(tree)
    minimax = described_class.new(-1)
    strategy = minimax.evaluate(tree)
    strategy
  end

  def leaf(score)
    spy "leaf scored: #{score}", :childs => [], :score => score
  end

  describe 'given a leaf node' do
    describe 'there is no strategy possible' do
      it do
        expect(strategy leaf 1)
        .to eq([])
      end

      it do
        expect(strategy leaf(-1))
        .to eq([])
      end

      it do
        expect(strategy leaf 0)
        .to eq([])                    
      end
    end
  end

  def tree(childs)
    spy "tree, childs: #{childs.to_s}", :childs => childs
  end
  
  describe 'given a one-leaf one-level tree' do
    it 'does not ask the root for the score' do
      root = tree [leaf(1)]
      strategy root
      expect(root).not_to have_received(:score)
    end

    describe 'has that leaf as the only strategy' do
      it do
        leaf = leaf(1)
        expect(strategy tree [leaf])
        .to eq([leaf])
      end

      it do
        leaf = leaf(-1)
        expect(strategy tree [leaf])
        .to eq([leaf])
      end

      it do
        leaf = leaf(0)
        expect(strategy tree [leaf])
        .to eq([leaf])
      end
    end
  end

  describe 'given a multiple-leaves one-level tree' do
    describe 'chooses the best leaves' do
      it do
        best_leaf = leaf(1)
        expect(strategy tree [best_leaf, leaf(0)])
        .to eq([best_leaf])
      end

      it do
        best_leaf = leaf(0)
        expect(strategy tree [best_leaf, leaf(-1)])
        .to eq([best_leaf])
      end

      it do
        best_leaf = leaf(1)
        expect(strategy tree [leaf(0), best_leaf])
        .to eq([best_leaf])
      end

      it do
        best_leaf = leaf(0)
        expect(strategy tree [leaf(-1), best_leaf])
        .to eq([best_leaf])
      end

      it do
        leaf1 = leaf(1)
        leaf2 = leaf(1)
        expect(strategy tree [leaf1, leaf2])
        .to eq([leaf1, leaf2])
      end

      it do
        leaf2 = leaf(1)
        leaf3 = leaf(1)
        expect(strategy tree [leaf(0), leaf2, leaf3])
        .to eq([leaf2, leaf3])
      end

      it do
        leaf1 = leaf(1)
        leaf3 = leaf(1)
        expect(strategy tree [leaf1, leaf(0), leaf3])
        .to eq([leaf1, leaf3])
      end
    end
  end

  describe 'given a two-level one-leaf tree' do
    it 'does not ask the subtree for the score' do
      subtree = tree [leaf(1)]
      strategy tree [subtree]
      expect(subtree).not_to have_received(:score)
    end

    it do
      subtree = tree [leaf(1)]
      expect(strategy tree [subtree])
      .to eq([subtree])
    end
  end

  describe 'given complex tree' do
    describe 'chooses an immediate better option' do
      it do
        best_option = leaf(1)
        root = tree([
          best_option,
          tree([
            leaf(0)
          ]),
        ])

        expect(strategy root)
        .to eq([best_option])
      end

      it do
        best_option = leaf(1)
        root = tree([
          tree([
            leaf(0)
          ]),
          best_option,
        ])

        expect(strategy root)
        .to eq([best_option])
      end
    end

    it 'chooses a better option even if it is one-level deep' do
      best_option = tree([
        leaf(1)
      ])
      root = tree([
        leaf(0),
        best_option,
      ])

      expect(strategy root)
      .to eq([best_option])
    end
  end
end
