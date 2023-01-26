namespace Zoom{
    float Render(float zoom){
        UI::SetNextWindowSize(200, 60);
        if(UI::Begin("Zoom Level", UI::WindowFlags::NoCollapse | UI::WindowFlags::NoResize | UI::WindowFlags::NoScrollbar)){
            UI::SetNextItemWidth(190);
            zoom = UI::SliderFloat("###zoomslider", zoom, 0.01, 5.0);
        }
        UI::End();
        return zoom;
    }
}