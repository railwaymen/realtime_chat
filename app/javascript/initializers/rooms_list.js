// React
import React from "react";
import ReactDOM from "react-dom";

// Components
import RoomsList from "@/components/rooms_list/RoomsList";

const initializeRoomsList = data => {
  console.log(data)
  const el = document.querySelector('#rooms-list__component[data-behavior="react"]')
  if (el != null) ReactDOM.render(<RoomsList rooms={data} />, el);
};

export default initializeRoomsList;
