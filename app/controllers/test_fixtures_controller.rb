require 'ostruct'

class TestFixturesController < ApplicationController
  layout nil

  def show
    @data = OpenStruct.new(params[:data] || {})
    render "test_fixtures/#{params[:id]}"
  end
end