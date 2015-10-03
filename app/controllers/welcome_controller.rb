class WelcomeController < ApplicationController

  def search
    begin
      record = Record.find_by_value(params[:userdata])
    rescue => e 
      redirect_to root_url, :flash => { :error => "#{e}" }
      return
    end
    unless record.valid?
      redirect_to root_url, :flash => { :error => "Record Invalid" }
      return
    end
    respond_to do |format|
      format.json { render json: record.params }
    end
  end

  def next
    begin
      record = Record.find_by_id(params[:id]).next()
    rescue => e
      redirect_to :back, :flash => { :error => "#{e}" }
      return
    end
    unless record.valid?
      redirect_to :back, :flash => { :error => "Record Invalid" }
      return
    end
    respond_to do |format|
      format.json { render json: record.params }
    end
  end

end
