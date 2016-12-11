require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    clean_datastore

    @note = Note.new(
      title: "Title",
      link: "http://example.com",
      comment: "things",
      parent_id: nil
    )

    @note.save
  end

  test "should get index" do
    get notes_url
    assert_response :success
  end

  test "should get new" do
    get new_note_url
    assert_response :success
  end

  test "should create note" do
    post notes_url, params: { note: { comment: @note.comment, link: @note.link, parent_id: @note.parent_id, title: @note.title } }

    assert_redirected_to notes_url + '#note-' + (@note.id + 1).to_s
  end

  test "should show note" do
    get note_url(@note)
    assert_redirected_to notes_url + '#note-' + @note.id.to_s
  end

  test "should get edit" do
    get edit_note_url(@note)
    assert_response :success
  end

  test "should update note" do
    patch note_url(@note), params: { note: { comment: @note.comment, link: @note.link, parent_id: @note.parent_id, title: @note.title } }
    assert_redirected_to note_path(@note)
  end

  test "should destroy note" do
    delete note_url(@note)

    assert_redirected_to notes_url
  end
end
