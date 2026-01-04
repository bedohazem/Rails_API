class ApplicationController < ActionController::API
  before_action :authenticate!

  attr_reader :current_user

  
    rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Not found" }, status: :not_found
    end


  private

  def authenticate!
    header = request.headers["Authorization"]
    token = header&.split&.last
    return render(json: { error: "Missing token" }, status: :unauthorized) if token.blank?

    payload = JwtService.decode(token)
    @current_user = User.find(payload["user_id"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def require_admin!
    return if current_user&.admin?
    render json: { error: "Forbidden" }, status: :forbidden
  end
end
