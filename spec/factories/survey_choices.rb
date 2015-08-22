FactoryGirl.define do
  factory :survey_choice, :class => 'Survey::Choice' do
    text "MyString"
question nil
sort 1
picture "MyString"
  end

end
