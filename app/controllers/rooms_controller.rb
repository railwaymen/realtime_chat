class RoomsController < BaseController
  before_action :fetch_rooms

  def index; end

  def new
    @room = Room.new
  end

  def show
    @room = Room.kept.find(params[:id])
    @messages = @room.messages.includes(:user).order(id: :asc)

    @room_message = RoomMessage.new(room: @room)
    @room_messages = @room.messages.kept.includes(:user)
  end

  def create
    @room = current_user.rooms.build room_params

    if @room.save
      AppChannel.broadcast_to('app', data: room_representation, type: :room_create)

      flash[:success] = "Room #{@room.name} has been created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
    @room = current_user.rooms.kept.find(params[:id]) 
  end

  def update
    @room = current_user.rooms.kept.find(params[:id])

    if @room.update(room_params)
      AppChannel.broadcast_to('app', data: room_representation, type: :room_update)

      flash[:success] = "Room #{@room.name} has been updated successfully"
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    @room = current_user.rooms.kept.find(params[:id])
    @room.discard

    AppChannel.broadcast_to('app', data: room_representation, type: :room_destroy)

    redirect_to rooms_path, notice: "Room #{@room.name} has been closed successfully"
  end

  private

  def fetch_rooms
    @rooms = Room.kept.order(name: :asc)
  end

  def room_params
    params.require(:room).permit(:name)
  end

  def room_representation
    json = ApplicationController.renderer.render(
      partial: 'api/v1/rooms/room',
      locals: {
        room: @room,
        current_user: current_user
      }
    )

    JSON.parse(json)
  end
end