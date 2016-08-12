class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # if not admin, just force them to the current user.
  def non_admin_to_current
    unless current_user.admin?
      if @user != current_user
        @user = current_user
      end
    end
  end

  def prevent_non_admin
    unless current_user.admin?
      redirect_to user_path (current_user)
    end
  end


  # GET /users
  # GET /users.json
  def index
    prevent_non_admin
    @users = User.all
    @users = @users.sort { |a, b| a <=> b }
  end

  # GET /users/1
  # GET /users/1.json
  def show
    non_admin_to_current
  end

  # GET /users/new
  def new
    prevent_non_admin
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    non_admin_to_current
  end

  # POST /users
  # POST /users.json
  def create
    # do I need admin here?
    prevent_non_admin
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
    non_admin_to_current
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
    prevent_non_admin
    # we may want to disable this.
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :pfs_number, :admin)
  end

end
