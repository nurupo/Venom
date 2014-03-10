/*
 *    ToxAVTest.vala
 *
 *    Copyright (C) 2013-2014  Venom authors and contributors
 *
 *    This file is part of Venom.
 *
 *    Venom is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    Venom is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with Venom.  If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * Using example code from https://wiki.gnome.org/Projects/Vala/GStreamerSample
 */

using Gtk;
using Gst;

public class VideoSample : Window {

    private Tox.Tox tox;
    private ToxAV.ToxAV tox_av;
    private DrawingArea drawing_area;
    private Pipeline pipeline;
    private Element src;
    private Element asrc;
    private Element sink;
    private Element asink;
    private ulong xid;

    public VideoSample () {
        create_widgets ();
        setup_gst_pipeline ();
        tox = new Tox.Tox(0);
        //tox_av = new ToxAV.ToxAV(tox, 800, 600);
    }

    private void create_widgets () {
        var vbox = new Box (Orientation.VERTICAL, 0);
        this.drawing_area = new DrawingArea ();
        this.drawing_area.realize.connect(on_realize);
        vbox.pack_start (this.drawing_area, true, true, 0);

        var play_button = new Button.from_stock (Stock.MEDIA_PLAY);
        play_button.clicked.connect (on_play);
        var stop_button = new Button.from_stock (Stock.MEDIA_STOP);
        stop_button.clicked.connect (on_stop);
        var quit_button = new Button.from_stock (Stock.QUIT);
        quit_button.clicked.connect (Gtk.main_quit);

        var bb = new ButtonBox (Orientation.HORIZONTAL);
        bb.add (play_button);
        bb.add (stop_button);
        bb.add (quit_button);
        vbox.pack_start (bb, false, true, 0);

        add (vbox);
    }

    private void setup_gst_pipeline () {
        this.pipeline = new Pipeline ("mypipeline");
#if OSX
        GLib.assert_not_reached();
#elif WIN32
        GLib.assert_not_reached();
#elif UNIX
        this.src = ElementFactory.make ("v4l2src", "video");
        this.asrc = ElementFactory.make("pulsesrc", "audio");
        this.sink = ElementFactory.make ("xvimagesink", "sink");
        this.asink = ElementFactory.make("autoaudiosink", "asink");
#else
        GLib.assert_not_reached();
#endif
        this.pipeline.add_many (this.src, this.asrc, this.sink, this.asink);
        this.src.link (this.sink);
        this.asrc.link(this.asink);
    }
    private void on_realize() {
#if OSX
        GLib.assert_not_reached();
#elif WIN32
        GLib.assert_not_reached();
#elif UNIX
        this.xid = (ulong)Gdk.X11Window.get_xid(this.drawing_area.get_window());
#else
        GLib.assert_not_reached();
#endif
    }

    private void on_play () {
        var xoverlay = this.sink as XOverlay;
        xoverlay.set_xwindow_id (this.xid);
        this.pipeline.set_state (State.PLAYING);
    }

    private void on_stop () {
        this.pipeline.set_state (State.READY);
    }

    public static int main (string[] args) {
        Gst.init (ref args);
        Gtk.init (ref args);

        var sample = new VideoSample ();
        sample.show_all ();

        Gtk.main ();

        return 0;
    }
}