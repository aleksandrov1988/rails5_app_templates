class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_login
  before_action :set_current_user


  def current_login
    session[:zombie] || session['cas'] && session['cas']['user']
  end

  private


  def set_current_user
    return nil if current_login.blank?
    @current_user ||= User.where(login: current_login).first
  end

  def check_authentication
    if session.blank? || session['cas'].blank? || session['cas']['user'].blank? ||
      (request.get? && !request.xhr? && (session['cas']['last_validated_at'].blank? || session['cas']['last_validated_at'] < 15.minutes.ago))
      render text: 'Требуется авторизация', status: 401
    end
  end

  def check_current_user
    render_error unless @current_user
  end
  
  def render_error(error='Доступ запрещен', options={})
    @error=error
    status=options[:status] || 403
    respond_to do |format|
      format.html { render 'error', status: status }
      format.js { render js: %(alert("\#{@error}")), status: status }
      format.json { render json: {error: @error}, status: status }
      format.xml { render xml: {error: @error}, status: status }
    end
  end
end
