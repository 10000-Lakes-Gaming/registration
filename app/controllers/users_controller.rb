class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # if not admin, just force them to the current user.
  def admin_only
    if !current_user.admin?
      # redirect_to current_user
      current_user_only
    end
  end

  def current_user_only
    if @user != current_user
      @user = current_user
    end
  end

  def redirect_to_user
    redirect_to user_path (current_user)
  end

  # GET /users
  # GET /users.json
  def index
    if !current_user.admin?
      redirect_to_user
    end
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    admin_only
  end

  # GET /users/new
  def new
    admin_only
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    admin_only
  end

  # POST /users
  # POST /users.json
  def create
    # do I need admin here?
    if !current_user.admin?
      redirect_to_user
    end
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # we may want to disable this.
    # @user.destroy
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
    respond_to do |format|
      format.html { redirect_to @user  }
      format.json { render :show, status: :ok, location: @user }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email_address, :pfs_number, :admin)
    end
end
