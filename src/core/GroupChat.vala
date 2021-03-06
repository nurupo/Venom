/*
 *    GroupChat.vala
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

namespace Venom {
  public class GroupChat : IContact, GLib.Object{

    public uint8[] public_key  { get; set; default = null; }
    public int group_id        { get; set; default = -1;   }
    public string local_name   { get; set; default = "";   }
    public Gdk.Pixbuf? image   { get; set; default = null; }
    public int peer_count      { get; set; default = 0;    }
    public int unread_messages { get; set; default = 0;    }
    public GLib.HashTable<int, GroupChatContact> peers
                               { get; set; }

    public GroupChat(uint8[] public_key, int group_id = -1) {
      this.public_key = public_key;
      this.group_id = group_id;
      this.peers = new GLib.HashTable<int, GroupChatContact>(null, null);
    }
    public GroupChat.from_id(int group_id) {
      this.group_id = group_id;
      this.peers = new GLib.HashTable<int, GroupChatContact>(null, null);
    }

    public string get_name_string() {
      return local_name == "" ? "Groupchat #%i".printf(group_id) : Markup.escape_text(local_name);
    }
    public string get_name_string_with_hyperlinks() {
      return get_name_string();
    }
    public string get_status_string() {
      if(peer_count > 1) {
        return "%i people connected".printf(peer_count);
      } else if(peer_count > 0) {
        return "%i person connected".printf(peer_count);
      } else {
        return "no one connected";
      }
    }
    public string get_status_string_with_hyperlinks() {
      return get_status_string();
    }
    public string get_status_string_alt() {
      return get_status_string();
    }
    public string get_last_seen_string() {
      return "";
    }
    public string get_tooltip_string() {
      StringBuilder b = new StringBuilder();
      b.append(get_name_string_with_hyperlinks());
      b.append_c('\n');
      b.append(get_status_string_alt());
      return b.str;
    }
  }
}
