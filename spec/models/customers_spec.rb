RSpec.describe Customer do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :first_name }
  end

  describe 'relationships' do

  end

  describe 'methods' do

  end
end