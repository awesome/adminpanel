require "spec_helper"

describe "Gallery pages" do
	subject {page}

	let(:user) { Factory(:user) }
	before do 
		visit adminpanel.signin_path
		valid_signin(user)
		clean_uploads_folder
	end
	
	describe "galleries" do
		let(:gallery) { Factory(:gallery) }
		before do
			visit adminpanel.galleries_path
		end

		it { should have_link(I18n.t("gallery.new"), adminpanel.new_gallery_path)}
		it { should have_link("i", adminpanel.gallery_path(gallery)) }
		it { should have_link("i", adminpanel.edit_gallery_path(gallery)) }
		it { should have_link("i", adminpanel.move_to_better_gallery_path(gallery)) }
		it { should have_link("i", adminpanel.move_to_worst_gallery_path(gallery)) }
	end

	describe "when creating" do
		describe "a single image" do
			let(:gallery) { Factory(:gallery)}
			it { gallery.position.should eq 1 }
		end

		describe "3 images" do
			let!(:gallery_1) { Factory(:gallery) }
			let!(:gallery_2) { Factory(:gallery) }
			let!(:gallery_3) { Factory(:gallery) }

			it { gallery_2.position.should eq 2 }
			it { gallery_3.position.should eq 3 }
			describe "when moving down the image in position 1" do
				before do
					gallery_1.move_to_worst_position
					gallery_2.reload
					gallery_3.reload
				end

				it { gallery_1.move_to_worst_position.should eq true}
				it { gallery_3.move_to_worst_position.should eq false}
				it { gallery_1.position.should eq 2}
				it { gallery_2.position.should eq 1}
				it { gallery_3.position.should eq 3}

				after do
					gallery_1.position = 1
					gallery_2.position = 2
					gallery_3.position = 3
				end
			end

			describe "when moving up the image in position 2" do
				before do
					gallery_2.move_to_better_position
					gallery_1.reload
					gallery_3.reload
				end

				it { gallery_1.move_to_better_position.should eq true}
				it { gallery_2.move_to_better_position.should eq false}
				it { gallery_1.position.should eq 2}
				it { gallery_2.position.should eq 1}
				it { gallery_3.position.should eq 3}

				after do
					gallery_1.position = 1
					gallery_2.position = 2
					gallery_3.position = 3
				end
			end

			describe "when deleting the image in position 1" do
				before do
					gallery_1.destroy
					gallery_2.reload
					gallery_3.reload
				end

				it { gallery_2.position.should eq 1}
				it { gallery_3.position.should eq 2}
			end
		end
	end

	describe "new" do
		before do 
			visit adminpanel.new_gallery_path
		end

		it { should have_title(I18n.t("gallery.new")) }

		describe "with invalid information" do
			before { find("form#new_gallery").submit_form! }

			it { should have_title(I18n.t("gallery.new")) }
			it { should have_selector("div#alerts") }
		end

		describe "with valid information" do
			before do
				attach_file('gallery_file', File.join(Rails.root, '/app/assets/images/hipster.jpg'))
				find("form#new_gallery").submit_form!
			end

			it { should have_content(I18n.t("gallery.success"))}
			it { File.exists? File.join(Rails.root, '/public/uploads/gallery/file/1/thumb_hipster.jpg') }
		end
	end

	describe "show" do
		let(:gallery) { Factory(:gallery) }
		before do
			visit adminpanel.gallery_path(gallery)
		end

		it { page.should have_selector("img", :src => gallery.file_url) }
	end
end