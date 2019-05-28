class RoomsController < BaseController
  def index
    @rooms = Room.all
  end

  def new
    @rooms = Room.all
    @room = Room.new
  end
  
  def show
    @rooms = Room.all
    @room = Room.find(params[:id])
    @room_message = RoomMessage.new(room: @room)
  end

  def create
    @rooms = Room.all
    @room = current_user.rooms.build room_params

    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
    @rooms = Room.all
    @room = current_user.rooms.find(params[:room_id]) 
  end

  def update
    @rooms = Room.all
    @room = current_user.rooms.find(params[:room_id]) 
    if @room.update(room_params)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end