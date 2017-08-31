require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

	def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
	end

  
	test "should be valid" do
		assert @relationship.valid?
	end

	test "should require a follower_id" do
		# idがない状況で有効な状況を作らないため
		@relationship.follower_id = nil
    	assert_not @relationship.valid?
	end

	test "should require a followed_id" do
		# idがない状況で有効な状況を作らないため
		@relationship.followed_id = nil
    	assert_not @relationship.valid?
	end
end
