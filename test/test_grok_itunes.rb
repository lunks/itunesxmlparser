#!/usr/bin/env ruby -w

$: << 'lib'

require 'test/unit'
require 'grok_itunes'
require 'time'
require 'pp'

##
# Student Name: John Howe
# Homework Week: 8
#

$testfile = "./big.itunes.xml"

class TestGrokITunes < Test::Unit::TestCase
  # accelerate read-only tests
  static_data = GrokITunes.new($testfile)
  static_data.parse_xml
  static_data.init_db
  static_data.populate_db
  @@static_db = static_data.db
  @@static_tracks = static_data.tracks
  @@static_playlists = static_data.playlists

  def setup
    @grok = GrokITunes.new($testfile)
    @grok.db = @@static_db
    @grok.tracks = @@static_tracks
    @grok.playlists = @@static_playlists
  end

  def test_init_valid_file_no_file
    assert_raise FileNotFoundException do
      @test = GrokITunes.new("./this_missing_file.xml")
    end
  end

  def test_init_valid_file_empty_file
    assert_raise FileEmptyException do
      @test = GrokITunes.new("./empty.xml")
    end
  end

  def test_fix_type_boolean_true
    actual_true = @grok.fix_type("true", "boolean")
    expected_true = true
    assert_equal expected_true, actual_true
    assert_instance_of TrueClass, actual_true
  end

  def test_fix_type_boolean_false
    actual_false = @grok.fix_type("false", "boolean")
    expected_false = false
    assert_equal expected_false, actual_false
    assert_instance_of FalseClass, actual_false
  end

  def test_fix_type_boolean_bogon
    assert_raise NonBooleanValueException do
      actual_bogon = @grok.fix_type("bogon", "boolean")
    end
  end

  def test_fix_type_date
    actual = @grok.fix_type("2008-08-30T19:55:51Z", "date")
    expected = "2008-08-30T19:55:51"
    assert_equal expected, actual
    assert_instance_of String, actual
  end

  def test_fix_type_integer_fixnum
    actual = @grok.fix_type("2", "integer")
    expected = 2
    assert_equal expected, actual
    assert_instance_of Fixnum, actual
  end

  def test_fix_type_integer_bignum
    actual = @grok.fix_type("3310678273", "integer")
    expected = 3310678273
    assert_equal expected, actual
    assert_instance_of Bignum, actual
  end

  def test_fix_type_string
    actual = @grok.fix_type("Test", "string")
    expected = "Test"
    assert_equal expected, actual
    assert_instance_of String, actual
  end

  def test_fix_type_unknown
    assert_raise UnknownDataTypeException do
      actual = @grok.fix_type("<xml>test</xml>", "xml")
    end
  end
  
  def test_human_clock_time_int
    actual = @grok.human_clock_time(276854)
    expected = "003:04:54:14"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_minute
    actual = @grok.human_clock_time(60)
    expected = "000:00:01:00"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_hour
    actual = @grok.human_clock_time(3600)
    expected = "000:01:00:00"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_day
    actual = @grok.human_clock_time(86400)
    expected = "001:00:00:00"
    assert_equal expected, actual
  end

  def test_parse_xml_tracks_array_size
    actual = @grok.tracks.size
    expected = 4248
    assert_equal expected, actual
  end
  
  def test_parse_xml_tracks_array_record_66_album
    actual_album = @grok.tracks[66][:album]
    expected_album = "Treasure"
    assert_equal expected_album, actual_album
    assert_instance_of String, actual_album
  end

  def test_parse_xml_tracks_array_record_66_album_artist
    actual_album_artist = @grok.tracks[66][:album_artist]
    expected_album_artist = nil
    assert_equal expected_album_artist, actual_album_artist
    # assert_instance_of String, actual_album_artist
  end

  def test_parse_xml_tracks_array_record_66_album_rating
    actual_album_rating = @grok.tracks[66][:album_rating]
    expected_album_rating = 80
    assert_equal expected_album_rating, actual_album_rating
    assert_instance_of Fixnum, actual_album_rating
  end

  def test_parse_xml_tracks_array_record_66_album_rating_computed
    actual_album_rating_computed = @grok.tracks[66][:album_rating_computed]
    expected_album_rating_computed = true
    assert_equal expected_album_rating_computed, actual_album_rating_computed
    assert_instance_of TrueClass, actual_album_rating_computed
  end

  def test_parse_xml_tracks_array_record_66_artist
    actual_artist = @grok.tracks[66][:artist]
    expected_artist = "Cocteau Twins"
    assert_equal expected_artist, actual_artist
    assert_instance_of String, actual_artist
  end

  def test_parse_xml_tracks_array_record_66_artwork_count
    actual_artwork_count = @grok.tracks[66][:artwork_count]
    expected_artwork_count = 1
    assert_equal expected_artwork_count, actual_artwork_count
    assert_instance_of Fixnum, actual_artwork_count
  end

  def test_parse_xml_tracks_array_record_66_bit_rate
    actual_bit_rate = @grok.tracks[66][:bit_rate]
    expected_bit_rate = 128
    assert_equal expected_bit_rate, actual_bit_rate
    assert_instance_of Fixnum, actual_bit_rate
  end

  def test_parse_xml_tracks_array_record_66_composer
    actual_composer = @grok.tracks[66][:composer]
    expected_composer = "Cocteau Twins"
    assert_equal expected_composer, actual_composer
    assert_instance_of String, actual_composer
  end

  def test_parse_xml_tracks_array_record_66_date_added
    actual_date_added = @grok.tracks[66][:date_added]
    expected_date_added = "2002-07-17T20:41:10"
    assert_equal expected_date_added, actual_date_added
    assert_instance_of String, actual_date_added
  end

  def test_parse_xml_tracks_array_record_66_date_modified
    actual_date_modified = @grok.tracks[66][:date_modified]
    expected_date_modified = "2005-10-18T17:03:07"
    assert_equal expected_date_modified, actual_date_modified
    assert_instance_of String, actual_date_modified
  end

  def test_parse_xml_tracks_array_record_66_disc_count
    actual_disc_count = @grok.tracks[66][:disc_count]
    expected_disc_count = 1
    assert_equal expected_disc_count, actual_disc_count
    assert_instance_of Fixnum, actual_disc_count
  end

  def test_parse_xml_tracks_array_record_66_disc_number
    actual_disc_number = @grok.tracks[66][:disc_number]
    expected_disc_number = 1
    assert_equal expected_disc_number, actual_disc_number
    assert_instance_of Fixnum, actual_disc_number
  end

  def test_parse_xml_tracks_array_record_66_file_creator
    actual_file_creator = @grok.tracks[66][:file_creator]
    expected_file_creator = nil
    assert_equal expected_file_creator, actual_file_creator
  end

  def test_parse_xml_tracks_array_record_66_file_folder_count
    actual_file_folder_count = @grok.tracks[66][:file_folder_count]
    expected_file_folder_count = 4
    assert_equal expected_file_folder_count, actual_file_folder_count
    assert_instance_of Fixnum, actual_file_folder_count
  end

  def test_parse_xml_tracks_array_record_66_genre
    actual_genre = @grok.tracks[66][:genre]
    expected_genre = "Goth"
    assert_equal expected_genre, actual_genre
    assert_instance_of String, actual_genre
  end

  def test_parse_xml_tracks_array_record_66_kind
    actual_kind = @grok.tracks[66][:kind]
    expected_kind = "AAC audio file"
    assert_equal expected_kind, actual_kind
    assert_instance_of String, actual_kind
  end

  def test_parse_xml_tracks_array_record_66_library_folder_count
    actual_library_folder_count = @grok.tracks[66][:library_folder_count]
    expected_library_folder_count = 1
    assert_equal expected_library_folder_count, actual_library_folder_count
    assert_instance_of Fixnum, actual_library_folder_count
  end

  def test_parse_xml_tracks_array_record_66_location
    actual_location = @grok.tracks[66][:location]
    expected_location = "file://localhost/Users/user_missing/Music/iTunes/iTunes%20Music/Cocteau%20Twins/Treasure/01%20Ivo.m4a"
    assert_equal expected_location, actual_location
    assert_instance_of String, actual_location
  end

  def test_parse_xml_tracks_array_record_66_name
    actual_name = @grok.tracks[66][:name]
    expected_name = "Ivo"
    assert_equal expected_name, actual_name
    assert_instance_of String, actual_name
  end

  def test_parse_xml_tracks_array_record_66_persistent_id
    actual_persistent_id = @grok.tracks[66][:persistent_id]
    expected_persistent_id = "3CF1F47A0CA8D0B1"
    assert_equal expected_persistent_id, actual_persistent_id
    assert_instance_of String, actual_persistent_id
  end

  def test_parse_xml_tracks_array_record_66_play_count
    actual_play_count = @grok.tracks[66][:play_count]
    expected_play_count = 41
    assert_equal expected_play_count, actual_play_count
    assert_instance_of Fixnum, actual_play_count
  end

  def test_parse_xml_tracks_array_record_66_play_date
    actual_play_date = @grok.tracks[66][:play_date]
    expected_play_date = 3309728375
    assert_equal expected_play_date, actual_play_date
    assert_instance_of Bignum, actual_play_date
  end

  def test_parse_xml_tracks_array_record_66_play_date_utc
    actual_play_date_utc = @grok.tracks[66][:play_date_utc]
    expected_play_date_utc = "2008-11-17T08:59:35"
    assert_equal expected_play_date_utc, actual_play_date_utc
    assert_instance_of String, actual_play_date_utc
  end

  def test_parse_xml_tracks_array_record_66_purchased
    actual_purchased = @grok.tracks[66][:purchased]
    expected_purchased = nil
    assert_equal expected_purchased, actual_purchased
  end

  def test_parse_xml_tracks_array_record_66_rating
    actual_rating = @grok.tracks[66][:rating]
    expected_rating = 100
    assert_equal expected_rating, actual_rating
    assert_instance_of Fixnum, actual_rating
  end

  def test_parse_xml_tracks_array_record_66_release_date
    actual_release_date = @grok.tracks[66][:release_date]
    expected_release_date = nil
    assert_equal expected_release_date, actual_release_date
  end

  def test_parse_xml_tracks_array_record_66_sample_rate
    actual_sample_rate = @grok.tracks[66][:sample_rate]
    expected_sample_rate = 44100
    assert_equal expected_sample_rate, actual_sample_rate
    assert_instance_of Fixnum, actual_sample_rate
  end

  def test_parse_xml_tracks_array_record_66_size
    actual_size = @grok.tracks[66][:size]
    expected_size = 3934305
    assert_equal expected_size, actual_size
    assert_instance_of Fixnum, actual_size
  end

  def test_parse_xml_tracks_array_record_66_total_time
    actual_total_time = @grok.tracks[66][:total_time]
    expected_total_time = 233266
    assert_equal expected_total_time, actual_total_time
    assert_instance_of Fixnum, actual_total_time
  end

  def test_parse_xml_tracks_array_record_66_track_count
    actual_track_count = @grok.tracks[66][:track_count]
    expected_track_count = 10
    assert_equal expected_track_count, actual_track_count
    assert_instance_of Fixnum, actual_track_count
  end

  def test_parse_xml_tracks_array_record_66_track_id
    actual_track_id = @grok.tracks[66][:track_id]
    expected_track_id = 1045
    assert_equal expected_track_id, actual_track_id
    assert_instance_of Fixnum, actual_track_id
  end

  def test_parse_xml_tracks_array_record_66_track_number
    actual_track_number = @grok.tracks[66][:track_number]
    expected_track_number = 1
    assert_equal expected_track_number, actual_track_number
    assert_instance_of Fixnum, actual_track_number
  end

  def test_parse_xml_tracks_array_record_66_track_type
    actual_track_type = @grok.tracks[66][:track_type]
    expected_track_type = "File"
    assert_equal expected_track_type, actual_track_type
    assert_instance_of String, actual_track_type
  end

  def test_parse_xml_tracks_array_record_66_year
    actual_year = @grok.tracks[66][:year]
    expected_year = 1984
    assert_equal expected_year, actual_year
    assert_instance_of Fixnum, actual_year
  end

  # Playlist tests

  def test_parse_xml_playlists_array_size
    actual = @grok.playlists.size
    expected = 40
    assert_equal expected, actual
  end

  def test_parse_xml_playlists_genius_all_items
    actual_all_items = @grok.playlists[8][0][:all_items]
    expected_all_items = true
    assert_equal expected_all_items, actual_all_items
    assert_instance_of TrueClass, actual_all_items
  end
  
  def test_parse_xml_playlists_genius_distinguished_kind
    actual = @grok.playlists[8][0][:distinguished_kind]
    expected = 26
    assert_equal expected, actual
    assert_kind_of Fixnum, actual
  end

  def test_parse_xml_playlists_genius_genius_track_id
    actual = @grok.playlists[8][0][:genius_track_id]
    expected = 5381
    assert_equal expected, actual
    assert_instance_of Fixnum, actual
  end

  def test_parse_xml_playlists_genius_name
    actual_name = @grok.playlists[8][0][:name]
    expected_name = "Genius"
    assert_equal expected_name, actual_name
    assert_instance_of String, actual_name
  end
  
  def test_parse_xml_playlists_genious_playlist_id
    actual_playlist_id = @grok.playlists[8][0][:playlist_id]
    expected_playlist_id = 31144
    assert_equal expected_playlist_id, actual_playlist_id
    assert_instance_of Fixnum, actual_playlist_id
  end

  def test_parse_xml_playlists_genius_playlist_persistent_id
    actual_persistent_id = @grok.playlists[8][0][:playlist_persistent_id]
    expected_persistent_id = "AFBA9D1CC404A519"
    assert_equal expected_persistent_id, actual_persistent_id
    assert_instance_of String, actual_persistent_id
  end
  
  def test_parse_xml_playlists_genius_playlists
    actual_playlist_items = @grok.playlists[8][1]
    expected_playlist_items = [
      5381,3037,2633,3367,4213,3397,2949,1047,5677,6793,5345,1795,8921,2349,6361,
      3063,5371,3829,1775,953,1043,2631,6831,7083,2023,1767,5391,7897,4857,5973,
      4935,995,5357,5377,5491,8231,3047,3067,1889,8207,6835,7459,945,3041,2343,
      2025,5769,7249,1007,1273
    ]
    assert_equal expected_playlist_items, actual_playlist_items
    assert_instance_of Array, actual_playlist_items
  end

  # Database tests

  def test_init_db_create
    @test = GrokITunes.new("./test.xml")
    @test.init_db

    assert_instance_of SQLite3::Database, @test.db
    assert_nothing_raised do
      File.open("./test.xml.db")
    end
    assert File.size?("./test.xml.db") > 0
  end
  
  def test_populate_db
    @test = GrokITunes.new("./test.xml")
    @test.init_db

    assert_nothing_thrown do
      @test.populate_db
    end
    assert File.exist?("./test.xml.db")
    assert File.size("./test.xml.db") >= 8192
  end
  
  def test_populate_tracks_db_record_count
    actual_array_size = @grok.tracks.size
    expected_array_size = 4248
    assert_equal expected_array_size, actual_array_size

    actual_tracks = @grok.db.execute("select * from tracks").size.to_i
    expected_tracks = 4248
    assert_equal expected_tracks, actual_tracks
  end

  # Specification requirements

  def test_artist_count
    actual = @grok.count_artists
    expected = 247
    assert_equal expected, actual
  end

  def test_album_count
    actual = @grok.count_albums
    expected = 397
    assert_equal expected, actual
  end

  def test_track_count
    actual = @grok.count_tracks
    expected = 4248
    assert_equal expected, actual
  end

  def test_total_playtime
    actual = @grok.total_time
    expected = "014:06:27:51"
    assert_equal expected, actual
  end

  def test_top_artists
    actual = @grok.top_artists
    expected = [
      ["149", "Nine Inch Nails"],
      ["139", "Depeche Mode"],
      ["129", "The Cure"],
      ["120", "Siouxsie &#38; the Banshees"],
      ["95", "New Model Army"],
      ["89", "The Police"],
      ["88", "Cocteau Twins"],
      ["84", "Peter Murphy"],
      ["81", "DJ Krush"],
      ["77", "Bauhaus"]
    ]
    assert_equal expected, actual
  end

  def test_top_genres
    actual = @grok.top_genres
    expected = [
      ["1433", "Alternative"],
      ["727", "Goth"],
      ["640", "Electronic"],
      ["525", "Industrial"],
      ["407", "Rock"],
      ["222", "Punk"],
      ["67", "World"],
      ["60", "Podcast"],
      ["40", "Soundtrack"],
      ["38", "New Age"]
    ]
    assert_equal expected, actual
  end
  
  def test_top_tracks_on_rating_times_playcount
    actual = @grok.top_tracks_on_rating_times_playcount
    expected = [
      ["8000", "Carnage Visors", "The Cure", "2008-09-17 12:10:59"],
      ["6640", "Future Proof", "Massive Attack", "2008-10-02 05:57:15"],
      ["6500", "Group Four", "Massive Attack", "2008-09-17 18:54:47"],
      ["6400", "Teardrop", "Massive Attack", "2008-10-23 05:57:05"],
      ["6000", "Angel", "Massive Attack", "2008-10-07 12:51:24"],
      ["5800", "Special Cases", "Massive Attack", "2008-10-06 17:01:13"],
      ["5600", "Inertia Creeps", "Massive Attack", "2008-10-23 07:16:22"],
      ["5500", "Dissolved Girl", "Massive Attack", "2008-10-06 16:15:23"],
      ["5300", "No New Tale To Tell", "Love &#38; Rockets", "2008-11-03 01:48:38"],
      ["5100", "Risingson", "Massive Attack", "2008-10-18 08:53:14"]
    ]
    assert_equal expected, actual
  end
  
  def test_oldest_tracks
    actual = @grok.oldest_tracks
    expected = [
      ["2002-08-15 18:14:03", "Introduction"],
      ["2003-11-13 19:26:53", "Segue: Ramona A. Stone/I Am With Name"], 
      ["2003-12-23 08:02:11", "Mother / Oh Mein Pa Pa"],
      ["2003-12-23 08:59:40", "Shame"],
      ["2004-02-27 18:45:22", "Fourteen"],
      ["2004-03-22 04:31:04", "To Have And To Hold"],
      ["2004-04-20 06:52:50", "Over And Out"],
      ["2004-05-06 03:23:40", "The Theft"],
      ["2004-06-08 10:32:05", "Sins Of The Fathers"],
      ["2004-07-02 23:01:19", "Back On Earth"]
    ]
    assert_equal expected, actual
  end
  
  def test_top_tracks_aging_well
    @grok.now = Time.parse("Tue Dec 09 18:00:00 -0800 2008")
    actual = @grok.top_tracks_aging_well
    expected = [
      [35350,"Carnage Visors","The Cure","2008-09-17 12:10:59"],
      [28722,"Group Four","Massive Attack","2008-09-17 18:54:47"],
      [28017,"Future Proof","Massive Attack","2008-10-02 05:57:15"],
      [24858,"Angel","Massive Attack","2008-10-07 12:51:24"],
      [24640,"Teardrop","Massive Attack","2008-10-23 05:57:05"],
      [24121,"Special Cases","Massive Attack","2008-10-06 17:01:13"],
      [22873,"Dissolved Girl","Massive Attack","2008-10-06 16:15:23"],
      [21560,"Inertia Creeps","Massive Attack","2008-10-23 07:16:22"],
      [20794,"One Hundred Years","The Cure","2008-10-06 10:56:13"],
      [20715,"A Prayer For England","Massive Attack","2008-10-07 15:00:18"]
    ]
    assert_equal expected, actual
  end

#  def test_related_artists_to_massive_attack
#    actual = @grok.related_artists_to("Massive Attack")
#    expected = [
#      [ "100",   "Tricky"],
#      [ "88.11", "Portishead"],
#      [ "86.29", "Lamb"],
#      [ "85.56", "UNKLE"],
#      [ "70.22", "Hooverphonic"],
#      [ "66.65", "Morcheeba"],
#      [ "57.6",  "Sneaker Pimps"],
#      [ "54.42", "Massive Attack vs. Mad Professor"],
#      [ "53.85", "Thievery Corporation"],
#      [ "51.83", "Archive"]
#    ]
#    assert_equal expected, actual
# end

  def test_small_files_256_k
    actual = @grok.small_files(262144)
    expected = [
      [138823, "-", "ohGr", "file://localhost/Users/user_missing/Music/iTunes/iTunes%20Music/ohGr/Sunnypsyop/11%20-.m4a"],
      [138823, "-", "ohGr", "file://localhost/Users/user_missing/Music/iTunes/iTunes%20Music/ohGr/Sunnypsyop/12%20-.m4a"],
      [216760, "ALL", "Descendents", "file://localhost/Users/user_missing/Music/iTunes/iTunes%20Music/Descendents/ALL/01%20ALL.m4a"],
      [228155, "No, All", "Descendents", "file://localhost/Users/user_missing/Music/iTunes/iTunes%20Music/Descendents/ALL/03%20No,%20All.m4a"]
    ]
    assert_equal expected, actual
  end

  def test_rating_fanatic
    actual = @grok.rating_fanatic
    expected = [
      [0, 0, 56, 4248, 0.0132],
      [20, 110, 110, 4248, 0.0259],
      [40, 358, 358, 4248, 0.0843],
      [60, 1457, 1457, 4248, 0.343],
      [80, 1418, 1418, 4248, 0.3338],
      [100, 849, 849, 4248, 0.1999]
    ]
    assert_equal expected, actual
  end
  
  def test_find_buggy_itunes_files
    actual = @grok.find_buggy_itunes_files
    expected = []
    assert_equal expected, actual
    #Bill Frisell|Live 10.04.1996 NYC|02 02 - john zorn's masada &#38; bill frisell - live 10.04.1996 nyc|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/Bill%20Frisell/Live%2010.04.1996%20NYC/02%2002%20-%20john%20zorn's%20masada%20&#38;%20bill%20frisell%20-%20live%2010.04.1996%20nyc.mp3
    #Buck 65|North American Adonis [ep]|02 02 Side B|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/Compilations/North%20American%20Adonis%20%5Bep%5D/02%2002%2002%20Side%20B.mp3
    #Lewis Black|Revolver|02 02 02 02 02 Lewis Black [Revolver (outtakes from The White Album)] 02 Outtakes|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/Lewis%20Black/Revolver/02%2002%2002%2002%2002%2002%20Lewis%20Black%20%5BRevolver%20(outtakes%20from%20The%20White%20Album)%5D%2002%20Outtakes.mp3
    #...
  end
  
  def test_find_trailing_spaces_artist
    actual = @grok.find_trailing_spaces('artist')
    expected = []
    assert_equal expected, actual
    #(Gus Gus) 
    #01 Lost At Last 
    #03. Healer 
    #...
  end
  
  def test_find_trailing_spaces_album
    actual = @grok.find_trailing_spaces('album')
    expected = []
    assert_equal expected, actual
    #9 Dream 
    #02 
    #03 
    #...
  end
  
  def test_bad_track_names_mp3
    actual = @grok.bad_track_names('mp3')
    expected = []
    assert_equal expected, actual
    # Keepinit Steel (The Anvil Track).mp3|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/Amon%20Tobin/Unknown%20Album/_Keepinit%20Steel%20(The%20Anvil%20Track).mp3.mp3
    #-.mp3|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/08.%20Bark%20Pschosis/~08.%20Bark%20Pschosis/-.mp3.mp3
    #-Smith &#38; Mighty -06 -Quite frankly (DJ Lynx).mp3|file://localhost/Volumes/BAQUA/jhowe/Music/iTunes/iTunes%20Music/DJ/Kicks/-Smith%20&#38;%20Mighty%20-06%20-Quite%20frankly%20(DJ%20Lynx).mp3.mp3
    #...
  end
  
  def test_bad_track_names_m4a
    actual = @grok.bad_track_names('m4a')
    expected = []
    assert_equal expected, actual
    #nil, since purchase music is "perfect"
  end
  
  def test_clean_tracks
    actual = @grok.clean_tracks
    expected = []
    assert_equal expected, actual
  end
  
  def test_explicit_tracks
    actual = @grok.explicit_tracks
    expected = [
      ["Mosh", "Eminem", "Mosh - Single", true],
      ["Private Hell", "Iggy Pop", "Skull Ring", true],
      ["Mama Said Knock You Out", "LL Cool J", "LL Cool J: All World - Greatest Hits", true],
      ["Make Love Fuck War (Dirty Version)", "Moby &#38; Public Enemy", "Make Love Fuck War", true],
      ["Dead Souls", "Nine Inch Nails", "The Downward Spiral (Deluxe Edition)", true]
    ]
    assert_equal expected, actual
  end
  
  def test_not_rated
    actual = @grok.tracks_not_rated
    expected = [
      ["TEDTalks (video)", "Brewster Kahle", "TEDTalks : A digital library, free to the world - Brewster Kahle (2007)"],
      ["TEDTalks (video)", "Chris Abani", "TEDTalks : Telling stories of our shared humanity  - Chris Abani (2008)"],
      ["TEDTalks (video)", "Clay Shirky", "TEDTalks : Institutions vs. collaboration - Clay Shirky (2005)"],
      ["TEDTalks (video)", "Corneille Ewango", "TEDTalks : A hero of the Congo Basin forest - Corneille Ewango (2007)"],
      ["TEDTalks (video)", "David Gallo", "TEDTalks : The deep oceans: a ribbon of life - David Gallo (1998)"],
      ["TEDTalks (video)", "David S. Rose", "TEDTalks : 10 things to know before you pitch a VC for money - David S. Rose (2007)"],
      ["TEDTalks (video)", "Doris Kearns Goodwin", "TEDTalks : What we can learn from past presidents - Doris Kearns Goodwin (2008)"],
      ["TEDTalks (video)", "Freeman Dyson", "TEDTalks : Let's look for life in the outer solar system - Freeman Dyson (2003)"],
      ["TEDTalks (video)", "Garrett Lisi", "TEDTalks : Have I found the holy grail of physics? - Garrett Lisi (2008)"],
      ["TEDTalks (video)", "George Dyson", "TEDTalks : The birth of the computer - George Dyson (2003)"],
      ["TEDTalks (video)", "Graham Hawkes", "TEDTalks : Fly the seas on a submarine with wings - Graham Hawkes (2005)"],
      ["TEDTalks (video)", "Helen Fisher", "TEDTalks : The brain in love - Helen Fisher (2008)"],
      ["TEDTalks (video)", "Jane Goodall", "TEDTalks : Helping humans and animals live together in Africa - Jane Goodall (2007)"],
      ["TEDTalks (video)", "Jared Diamond", "TEDTalks : Why societies collapse - Jared Diamond (2003)"],
      ["TEDTalks (video)", "John Markoff", "TEDTalks : Why newspapers still matter (and why tech news belongs on the front page) - John Markoff (2007)"],
      ["TEDTalks (video)", "Jonathan Haidt", "TEDTalks : The real difference between liberals and conservatives - Jonathan Haidt (2008)"],
      ["TEDTalks (video)", "Jonathan Harris", "TEDTalks : The art of collecting stories - Jonathan Harris (2007)"],
      ["TEDTalks (video)", "Kevin Kelly", "TEDTalks : Predicting the next 5,000 days of the web - Kevin Kelly (2007)"],
      ["TEDTalks (video)", "Kwabena Boahen", "TEDTalks : Making a computer that works like the brain - Kwabena Boahen (2007)"],
      ["TEDTalks (video)", "Lee Smolin", "TEDTalks : How science is like democracy - Lee Smolin (2003)"],
      ["TEDTalks (video)", "Liz Diller", "TEDTalks : Architecture is a special effects machine - Liz Diller (2007)"],
      ["TEDTalks (video)", "Louise Leakey", "TEDTalks : Digging for humanity's origins - Louise Leakey (2008)"],
      ["TEDTalks (video)", "Luca Turin", "TEDTalks : The science of scent - Luca Turin (2005)"],
      ["TEDTalks (video)", "Newton Aduaka", "TEDTalks : The story of Ezra, a child soldier - Newton Aduaka (2007)"],
      ["TEDTalks (video)", "Nicholas Negroponte", "TEDTalks : One Laptop per Child, two years on - Nicholas Negroponte (2007)"],
      ["TEDTalks (video)", "Paola Antonelli", "TEDTalks : Design and the elastic mind - Paola Antonelli (2007)"],
      ["TEDTalks (video)", "Patricia Burchat", "TEDTalks : The search for dark energy and dark matter - Patricia Burchat (2008)"],
      ["TEDTalks (video)", "Paul Rothemund", "TEDTalks : The astonishing promise of DNA folding - Paul Rothemund (2008)"],
      ["TEDTalks (video)", "Peter Hirshberg", "TEDTalks : The Web and TV, a sibling rivalry - Peter Hirshberg (2007)"],
      ["TEDTalks (video)", "Robert Full", "TEDTalks : How engineers learn from evolution - Robert Full (2002)"],
      ["TEDTalks (video)", "Rodney Brooks", "TEDTalks : How robots will invade our lives - Rodney Brooks (2003)"],
      ["TEDTalks (video)", "Spencer Wells", "TEDTalks : Building a family tree for all humanity - Spencer Wells (2007)"],
      ["TEDTalks (video)", "Steven Johnson", "TEDTalks : The Web and the city as self-repairing  - Steven Johnson (2003)"],
      ["TEDTalks (video)", "Stewart Brand", "TEDTalks : Building a home for the Clock of the Long Now - Stewart Brand (2004)"],
      ["TEDTalks (video)", "Sugata Mitra", "TEDTalks : Can kids teach themselves? - Sugata Mitra (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks : Can we domesticate germs? - Paul Ewald (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks : Exploring the ocean's hidden worlds - Robert Ballard (2008)"],
      ["TEDTalks (video)", "TED", "TEDTalks : Sir Martin Rees (2005) video"],
      ["TEDTalks (video)", "TED", "TEDTalks : What's wrong with what we eat - Mark Bittman (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Brian Greene (2005)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Craig Venter (2005) video"],
      ["TEDTalks (video)", "TED", "TEDTalks: Ernest Madu (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Hector Ruiz (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Jill Taylor (2008)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Juan Enriquez (2003) video"],
      ["TEDTalks (video)", "TED", "TEDTalks: Juan Enriquez (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Karen Armstrong (2008)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Michael Pollan (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Neil Turok (2008)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Robert Full (2005)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Ron Eglash (2007)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Tod Machover, Dan Ellsey (2008)"],
      ["TEDTalks (video)", "TED", "TEDTalks: Yochai Benkler (2005)"],
      ["TEDTalks (video)", "Virginia Postrel", "TEDTalks : The power of glamour - Virginia Postrel (2004)"],
      ["TEDTalks (video)", "Wade Davis", "TEDTalks : The worldwide web of belief and ritual - Wade Davis (2008)"],
      ["iPhone Getting Started Videos", "Apple Developer Connection", "Fundamentals of Cocoa Session from WWDC"]
    ]
    assert_equal expected, actual
  end

  def test_podcast_without_genre
    actual = @grok.podcast_without_genre
    expected = [
      ["Bin Laden feat. Mos Def", "Immortal Technique"],
      ["Dollar Day for New Orleans ... Katrina Klap", "Mos Def"],
      ["Ryan Davis Vs Marthin Luter King [ Strano Mash Up ]", ""],
      ["The Other Voice", "King Black Acid"]
    ]
    assert_equal expected, actual
  end
  
  def test_spam_tunes
    actual = @grok.spam_tunes
    expected = [
      ["The Brunching Shuttlecocks", "www.brunching.com", "The Bjork Song"],
      ["dINbOT", "www.dinbot.com", "Bathroom Grammar (English Beat vs Nelly)"],
      ["dINbOT", "www.dinbot.com", "Beastie Bop (Ramones vs Beastie Boys)"],
      ["dINbOT", "www.dinbot.com", "Gay Paranoia (Black Sabbath vs Electric 6)"],
      ["dINbOT", "www.dinbot.com", "Hell On Wheelz (Thrill Kill Kult vs. No Doubt)"],
      ["dINbOT", "www.dinbot.com", "Paintin' Paintin' (Rolling Stones vs Destiny's Child)"],
      ["dINbOT", "www.dinbot.com", "Tom's Penis (King Missile vs. Suzanne Vega)"],
      ["dINbOT", "www.dinbot.com", "Whipsta (Devo vs. 50 Cent)"],
      ["dINbOT", "www.dinbot.com", "World of Flesh (One Inch Punch vs Morcheeba)"]
    ]
    assert_equal expected, actual
  end
  
  def test_never_played
    actual = @grok.never_played
    expected = [
      ["Alice Cooper", "Welcome To My Nightmare", "Cold Ethyl"],
      ["Alice Cooper", "Welcome To My Nightmare", "Department Of Youth"],
      ["Alice Cooper", "Welcome To My Nightmare", "Escape"],
      ["Alice Cooper", "Welcome To My Nightmare", "Only Women Bleed"],
      ["Alice Cooper", "Welcome To My Nightmare", "Some Folks"],
      ["Alice Cooper", "Welcome To My Nightmare", "The Awakening"],
      ["Alice Cooper", "Welcome To My Nightmare", "Years Ago"],
      ["Apple Developer Connection", "iPhone Getting Started Videos", "Fundamentals of Cocoa Session from WWDC"],
      ["Bauhaus", "Mask", "David Jay/Peter Murphy/Kevin Haskins/Daniel Ash"],
      ["Bethany Curve", "Gold", "(Unknown)"],
      ["Brewster Kahle", "TEDTalks (video)", "TEDTalks : A digital library, free to the world - Brewster Kahle (2007)"],
      ["Chris Abani", "TEDTalks (video)", "TEDTalks : Telling stories of our shared humanity  - Chris Abani (2008)"],
      ["Chrome", "Anthology 1979 - 1983", "Chromosome Damage"],
      ["Clay Shirky", "TEDTalks (video)", "TEDTalks : Institutions vs. collaboration - Clay Shirky (2005)"],
      ["Corneille Ewango", "TEDTalks (video)", "TEDTalks : A hero of the Congo Basin forest - Corneille Ewango (2007)"],
      ["Course Of Empire", "Course Of Empire", "Coming Of The Century"],
      ["David Gallo", "TEDTalks (video)", "TEDTalks : The deep oceans: a ribbon of life - David Gallo (1998)"],
      ["David J.", "V For Vendetta", "Incidental"],
      ["David S. Rose", "TEDTalks (video)", "TEDTalks : 10 things to know before you pitch a VC for money - David S. Rose (2007)"],
      ["Dead Kennedys", "Give Me Convenience or Give Me Death", "The Man With The Dogs"],
      ["Doris Kearns Goodwin", "TEDTalks (video)", "TEDTalks : What we can learn from past presidents - Doris Kearns Goodwin (2008)"],
      ["Freeman Dyson", "TEDTalks (video)", "TEDTalks : Let's look for life in the outer solar system - Freeman Dyson (2003)"],
      ["Garrett Lisi", "TEDTalks (video)", "TEDTalks : Have I found the holy grail of physics? - Garrett Lisi (2008)"],
      ["George Dyson", "TEDTalks (video)", "TEDTalks : The birth of the computer - George Dyson (2003)"],
      ["Graham Hawkes", "TEDTalks (video)", "TEDTalks : Fly the seas on a submarine with wings - Graham Hawkes (2005)"],
      ["Helen Fisher", "TEDTalks (video)", "TEDTalks : The brain in love - Helen Fisher (2008)"],
      ["Jane Goodall", "TEDTalks (video)", "TEDTalks : Helping humans and animals live together in Africa - Jane Goodall (2007)"],
      ["Jared Diamond", "TEDTalks (video)", "TEDTalks : Why societies collapse - Jared Diamond (2003)"],
      ["John Corigliano", "Red Violin", "People's Revolution; Death of Chou Yuan"],
      ["John Markoff", "TEDTalks (video)", "TEDTalks : Why newspapers still matter (and why tech news belongs on the front page) - John Markoff (2007)"],
      ["Jonathan Haidt", "TEDTalks (video)", "TEDTalks : The real difference between liberals and conservatives - Jonathan Haidt (2008)"],
      ["Jonathan Harris", "TEDTalks (video)", "TEDTalks : The art of collecting stories - Jonathan Harris (2007)"],
      ["Kevin Kelly", "TEDTalks (video)", "TEDTalks : Predicting the next 5,000 days of the web - Kevin Kelly (2007)"],
      ["Kevin MacLeod", "Royalty Free 2008", "Serpentine Trek"],
      ["Kill Sister Kill", "The Disease of Lady Madeline", "Poisonous Fix"],
      ["Kwabena Boahen", "TEDTalks (video)", "TEDTalks : Making a computer that works like the brain - Kwabena Boahen (2007)"],
      ["Lee Smolin", "TEDTalks (video)", "TEDTalks : How science is like democracy - Lee Smolin (2003)"],
      ["Liz Diller", "TEDTalks (video)", "TEDTalks : Architecture is a special effects machine - Liz Diller (2007)"],
      ["Louise Leakey", "TEDTalks (video)", "TEDTalks : Digging for humanity's origins - Louise Leakey (2008)"],
      ["Love &#38; Rockets", "Swing!", "Radio Session-Interview"],
      ["Luca Turin", "TEDTalks (video)", "TEDTalks : The science of scent - Luca Turin (2005)"],
      ["Ministry", "Animositisomina", "Stolen"],
      ["Newton Aduaka", "TEDTalks (video)", "TEDTalks : The story of Ezra, a child soldier - Newton Aduaka (2007)"],
      ["Nicholas Negroponte", "TEDTalks (video)", "TEDTalks : One Laptop per Child, two years on - Nicholas Negroponte (2007)"],
      ["Paola Antonelli", "TEDTalks (video)", "TEDTalks : Design and the elastic mind - Paola Antonelli (2007)"],
      ["Patricia Burchat", "TEDTalks (video)", "TEDTalks : The search for dark energy and dark matter - Patricia Burchat (2008)"],
      ["Paul Rothemund", "TEDTalks (video)", "TEDTalks : The astonishing promise of DNA folding - Paul Rothemund (2008)"],
      ["Peter Hirshberg", "TEDTalks (video)", "TEDTalks : The Web and TV, a sibling rivalry - Peter Hirshberg (2007)"],
      ["Peter Murphy", "Unshattered", "Blinded Like Saul"],
      ["Peter Murphy", "Unshattered", "Breaking No One's Heaven"],
      ["Peter Murphy", "Unshattered", "Emergency Unit"],
      ["Peter Murphy", "Unshattered", "Face the Moon"],
      ["Peter Murphy", "Unshattered", "Give What He's Got"],
      ["Peter Murphy", "Unshattered", "The First Stone"],
      ["Peter Murphy", "Unshattered", "The Weight of Love"],
      ["Peter Murphy", "Unshattered", "Thelma Sigs To Little Nell"],
      ["Robert Full", "TEDTalks (video)", "TEDTalks : How engineers learn from evolution - Robert Full (2002)"],
      ["Rodney Brooks", "TEDTalks (video)", "TEDTalks : How robots will invade our lives - Rodney Brooks (2003)"],
      ["Spencer Wells", "TEDTalks (video)", "TEDTalks : Building a family tree for all humanity - Spencer Wells (2007)"],
      ["Steven Johnson", "TEDTalks (video)", "TEDTalks : The Web and the city as self-repairing  - Steven Johnson (2003)"],
      ["Stewart Brand", "TEDTalks (video)", "TEDTalks : Building a home for the Clock of the Long Now - Stewart Brand (2004)"],
      ["Sugata Mitra", "TEDTalks (video)", "TEDTalks : Can kids teach themselves? - Sugata Mitra (2007)"],
      ["Swans", "Swans Are Dead (White Disc)", "Final Sac"],
      ["TED", "TEDTalks (video)", "TEDTalks : Can we domesticate germs? - Paul Ewald (2007)"],
      ["TED", "TEDTalks (video)", "TEDTalks : Exploring the ocean's hidden worlds - Robert Ballard (2008)"],
      ["TED", "TEDTalks (video)", "TEDTalks : Hans Rosling (2006) video"],
      ["TED", "TEDTalks (video)", "TEDTalks : Malcolm Gladwell (2004) video"],
      ["TED", "TEDTalks (video)", "TEDTalks : Sir Martin Rees (2005) video"],
      ["TED", "TEDTalks (video)", "TEDTalks : What's wrong with what we eat - Mark Bittman (2007)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Brian Greene (2005)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Craig Venter (2005) video"],
      ["TED", "TEDTalks (video)", "TEDTalks: Ernest Madu (2007)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Hector Ruiz (2007)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Jill Taylor (2008)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Juan Enriquez (2003) video"],
      ["TED", "TEDTalks (video)", "TEDTalks: Karen Armstrong (2008)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Neil Turok (2008)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Tod Machover, Dan Ellsey (2008)"],
      ["TED", "TEDTalks (video)", "TEDTalks: Yochai Benkler (2005)"],
      ["The Police", "Message In A Box: The Complete Recordings (Disc 3)", "A Kind Of Loving"],
      ["Virginia Postrel", "TEDTalks (video)", "TEDTalks : The power of glamour - Virginia Postrel (2004)"],
      ["Wade Davis", "TEDTalks (video)", "TEDTalks : The worldwide web of belief and ritual - Wade Davis (2008)"],
      ["Wumpscut", "The Mesner Tracks", "Ceremony (Remastered)"],
      ["Wumpscut", "The Mesner Tracks", "Cry Weisenstein Cry (Mad Mix)"]
    ]
    assert_equal expected, actual
  end
  
  def test_bitrate_histogram
    actual = @grok.bitrate_histogram
    expected = [
      ["1", 56],
      ["1", 64],
      ["1", 81],
      ["2", 90],
      ["2", 91],
      ["6", 92],
      ["7", 93],
      ["20", 94],
      ["6", 95],
      ["19", 96],
      ["10", 97],
      ["26", 98],
      ["43", 99],
      ["77", 100],
      ["79", 101],
      ["37", 102],
      ["24", 103],
      ["7", 104],
      ["1", 112],
      ["1", 115],
      ["1", 119],
      ["1", 120],
      ["3", 121],
      ["2", 122],
      ["3", 123],
      ["7", 124],
      ["20", 125],
      ["11", 126],
      ["5", 127],
      ["3678", 128],
      ["9", 129],
      ["2", 130],
      ["128", 160],
      ["5", 192],
      ["1", 256],
      ["2", 320]
    ]
    assert_equal expected, actual
  end
  
  def test_missing_track_numbers
    actual = @grok.missing_track_numbers
    expected = [
      ["", "", "LetsPoledance"],
      ["", "", "MadonnavsmixmastermacMusic"],
      ["", "", "Ryan Davis Vs Marthin Luter King [ Strano Mash Up ]"],
      ["", "", "Whotolddre"],
      ["Brazilian Girls", "Brazilian Girls Remix EP", "Crosseyed And Painless"],
      ["Crowded House vs Snoop Dogg", "", "Return Of The Weather Episode (remix) (Go Home Productions)"],
      ["DJ BC", "", "MilkShookMe"],
      ["DJ Te\303\253po", "", "Taint It"],
      ["Eminem vs Prodigy", "", "Superman (Asnivor Remix) (Breathe Mix)"],
      ["Go Home Productions", "", "Annie's Stoned Rush"],
      ["Go Home Productions", "", "David X"],
      ["Go Home Productions", "", "Notorious Trick"],
      ["Immortal Technique", "", "Bin Laden feat. Mos Def"],
      ["Kevin MacLeod", "Royalty Free 2008", "Serpentine Trek"],
      ["King Black Acid", "Mothman Prophecies", "The Other Voice"],
      ["Mos Def", "", "Dollar Day for New Orleans ... Katrina Klap"],
      ["The Legendary K.O.", "", "George Bush Doesn't Care About Black People"],
      ["dINbOT", "www.dinbot.com", "Bathroom Grammar (English Beat vs Nelly)"],
      ["dINbOT", "www.dinbot.com", "Beastie Bop (Ramones vs Beastie Boys)"],
      ["dINbOT", "www.dinbot.com", "Gay Paranoia (Black Sabbath vs Electric 6)"],
      ["dINbOT", "www.dinbot.com", "Hell On Wheelz (Thrill Kill Kult vs. No Doubt)"],
      ["dINbOT", "www.dinbot.com", "Paintin' Paintin' (Rolling Stones vs Destiny's Child)"],
      ["dINbOT", "www.dinbot.com", "Tom's Penis (King Missile vs. Suzanne Vega)"],
      ["dINbOT", "www.dinbot.com", "Whipsta (Devo vs. 50 Cent)"],
      ["dINbOT", "www.dinbot.com", "World of Flesh (One Inch Punch vs Morcheeba)"],
      ["smash@mash-ups.co.uk", "", "Wild Rock Music!"]
    ]
    assert_equal expected, actual
  end
  
  def test_missing_genre
    actual = @grok.missing_genre
    expected = [
      ["", "", "Ryan Davis Vs Marthin Luter King [ Strano Mash Up ]"],
      ["Immortal Technique", "", "Bin Laden feat. Mos Def"],
      ["King Black Acid", "Mothman Prophecies", "The Other Voice"],
      ["Mos Def", "", "Dollar Day for New Orleans ... Katrina Klap"]
    ]
    assert_equal expected, actual
  end
  
  def test_disk_pigs
    actual = @grok.disk_pigs
    expected = [
      [336141872, "Apple Developer Connection", "iPhone Getting Started Videos", "Fundamentals of Cocoa Session from WWDC"],
      [111450131, "Peter Hirshberg", "TEDTalks (video)", "TEDTalks : The Web and TV, a sibling rivalry - Peter Hirshberg (2007)"],
      [92263281, "TED", "TEDTalks (video)", "TEDTalks: Neil Turok (2008)"],
      [89178761, "TED", "TEDTalks (video)", "TEDTalks : Larry Brilliant (2006) video"],
      [87557094, "Jane Goodall", "TEDTalks (video)", "TEDTalks : Helping humans and animals live together in Africa - Jane Goodall (2007)"],
      [86808084, "Freeman Dyson", "TEDTalks (video)", "TEDTalks : Let's look for life in the outer solar system - Freeman Dyson (2003)"],
      [84714891, "Rodney Brooks", "TEDTalks (video)", "TEDTalks : How robots will invade our lives - Rodney Brooks (2003)"],
      [81551137, "Stewart Brand", "TEDTalks (video)", "TEDTalks : Building a home for the Clock of the Long Now - Stewart Brand (2004)"],
      [79665218, "TED", "TEDTalks (video)", "TEDTalks: Karen Armstrong (2008)"],
      [76916661, "Spencer Wells", "TEDTalks (video)", "TEDTalks : Building a family tree for all humanity - Spencer Wells (2007)"]
    ]
    assert_equal expected, actual
  end
  
  def test_dj_itis_skip_happy
    actual = @grok.dj_itis_skip_happy
    expected = [
      ["Alphaville", "Afternoons In Utopia", "Carol Masters", 1, 1],
      ["Pigface", "Truth Will Out", "Do No Wrong", 1, 1],
      ["Moby", "Rare: The Collected B-Sides (1989-1993)", "Thousand", 2, 2],
      ["Tony Scott", "Music for Zen Meditation and Other Joys", "The Murmuring Sound Of The Mountain Stream", 3, 2]
    ]
    assert_equal expected, actual
  end
  
  def test_screaming_names
    actual = @grok.screaming_names
    expected = [
      ["TV II", "Ministry", "Psalm 69"],
      ["M", "The Cure", "Seventeen Seconds"],
      ["E", "Sigur R\303\263s", "Agaetis Byrjun"],
      ["VIT", "The Future Sound Of London", "Lifeforms (Disc 2)"],
      ["GNMI", "Hitting Birth", "Kiss of the Last Three Years"],
      ["ALL", "Descendents", "ALL"]
    ]
    assert_equal expected, actual
  end
  
  def test_treemap_bitrate
    actual = @grok.treemap_bitrate
    expected = 14990
    assert_equal expected, actual
  end
  
  def test_genre_histogram
    actual = @grok.genre_histogram
    expected = [
      ["1433", "Alternative"],
      ["727", "Goth"],
      ["640", "Electronic"],
      ["525", "Industrial"],
      ["407", "Rock"],
      ["222", "Punk"],
      ["67", "World"],
      ["60", "Podcast"],
      ["40", "Soundtrack"],
      ["38", "New Age"],
      ["36", "Mashup"],
      ["32", "Hip-Hop/Rap"],
      ["9", "Blues"],
      ["4", ""],
      ["4", "Classical"],
      ["2", "Comedy"],
      ["1", "R&#38;B/Soul"],
      ["1", "Video"]
    ]
    assert_equal expected, actual
  end
  
  def test_treemap_genre
    actual = @grok.treemap_genre
    expected = 7972
    assert_equal expected, actual
  end
end
