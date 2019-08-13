require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '新規登録のテスト' do
    let(:current_user){ FactoryBot.create(:user) }
    let(:bean){ FactoryBot.create(:bean, user: current_user) }
    let(:review){ FactoryBot.build(:review, user: current_user) }

    context 'バリデーションのテスト' do
      before do
        review.targets.first.bean_id = bean.id
      end

      it '正常に登録できる場合' do
        expect(review).to be_valid
      end

      it 'titleが無ければ無効な状態であること' do
        review.title = ''
        review.valid?
        expect(review.errors[:title]).to include('を入力してください')
      end

      it 'titleが30文字以下なら有効な状態であること' do
        review.title = 'a' * 30
        expect(review).to be_valid
      end

      it 'titleが30文字より多いなら無効な状態であること' do
        review.title = 'a' * 31
        review.valid?
        expect(review.errors[:title]).to include('は30文字以内で入力してください')
      end

      it 'contentが無ければ無効な状態であること' do
        review.content = ''
        review.valid?
        expect(review.errors[:content]).to include('を入力してください')
      end

      it 'contentが1,000文字以下なら有効な状態であること' do
        review.content = 'a' * 1_000
        expect(review).to be_valid
      end

      it 'contentが30文字より多いなら無効な状態であること' do
        review.content = 'a' * 1_001
        review.valid?
        expect(review.errors[:content]).to include('は1000文字以内で入力してください')
      end

      it 'ratingに1から5以外の数字が入れば無効な状態であること' do
        review.rating = 0
        review.valid?
        expect(review.errors[:rating]).to include('は一覧にありません')
        review.rating = 6
        review.valid?
        expect(review.errors[:rating]).to include('は一覧にありません')
      end

      it 'bitterに1から5以外の数字が入れば無効な状態であること' do
        review.bitter = 0
        review.valid?
        expect(review.errors[:bitter]).to include('は一覧にありません')
        review.bitter = 6
        review.valid?
        expect(review.errors[:bitter]).to include('は一覧にありません')
      end

      it 'acidityに1から5以外の数字が入れば無効な状態であること' do
        review.acidity = 0
        review.valid?
        expect(review.errors[:acidity]).to include('は一覧にありません')
        review.acidity = 6
        review.valid?
        expect(review.errors[:acidity]).to include('は一覧にありません')
      end

      it 'richに1から5以外の数字が入れば無効な状態であること' do
        review.rich = 0
        review.valid?
        expect(review.errors[:rich]).to include('は一覧にありません')
        review.rich = 6
        review.valid?
        expect(review.errors[:rich]).to include('は一覧にありません')
      end

      it 'sweetに1から5以外の数字が入れば無効な状態であること' do
        review.sweet = 0
        review.valid?
        expect(review.errors[:sweet]).to include('は一覧にありません')
        review.sweet = 6
        review.valid?
        expect(review.errors[:sweet]).to include('は一覧にありません')
      end

      it 'aromaに1から5以外の数字が入れば無効な状態であること' do
        review.aroma = 0
        review.valid?
        expect(review.errors[:aroma]).to include('は一覧にありません')
        review.aroma = 6
        review.valid?
        expect(review.errors[:aroma]).to include('は一覧にありません')
      end

      it 'drank_onに未来の日付を入力すると無効な状態であること' do
        review.drank_on = Date.tomorrow
        review.valid?
        expect(review.errors[:drank_on]).to include('に未来の日付は入力できません')
      end

      it 'targetモデルとの関連付けが無いと無効な状態であること' do
        # binding.pry
        review.targets.clear
        review.valid?
        expect(review.errors[:targets]).to include('を入力してください')
      end
    end
  end
end
