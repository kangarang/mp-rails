class GraphqlController < ApplicationController

  def query
    result_hash = SuperSchema.execute(params[:query], variables: params[:variables])
    render json: result_hash
  end
end
