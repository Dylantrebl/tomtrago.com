class PagesController < ActionController::Base

  before_action :authenticate_user!
  respond_to :html
  before_action :check_user
  before_action :set_pages, only: %i[index show]

  def index; end

  def show
    @page = Page.find_by(id: params[:id])

    redirect_to action: index if @page.nil?
  end

  def create
    page = Page.new(params)

    if page.save
      redirect_to page_url(page), action: :get
    else
      redirect_to action: error, status: :unprocessable_entity
    end
  end

  def update
    page = Page.find(params[:id])

    unless page.update(page_params)
      render json: page.errors, status: :unprocessable_entity
    end
  end

  private

  def check_user
    p "signed in: #{user_signed_in?}"
    #redirect_to '/login' if !user_signed_in?
  end

  def page_params
    permitted_params = %i[
      id
      href
      link
      published
      title
      content
    ]

    params.require(:page).permit(permitted_params)
  end

  def set_pages
    @pages = Page.all.order(:title)
  end
end
