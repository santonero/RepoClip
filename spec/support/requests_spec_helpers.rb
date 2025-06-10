module RequestsSpecHelpers
  def login_as(user)
    post session_path, params: { account: user.username, password: "Password123!" }, as: :turbo_stream
    expect(session[:user_id]).to eq(user.id)
  end
end

RSpec.configure do |config|
  config.include RequestsSpecHelpers, type: :request
end