// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Token interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Blog {

  //Matic deployment address
  address internal maticTokenAddress = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
  
  //Add current post id here
  uint256 public newPostId =0;

  //Structure for user information
  struct Author {
    string username;
    string bio;
    uint256[] postId;
  }

  //Structure for posts
  struct Post {
    string title;
    string content;
    address writer;
    uint256 created;
  }

  //Mapping

  mapping (address => Author) public authors;
  mapping (uint256 => Post) public posts;

   /**
       * @dev events are signals that are triggred which dispatches information.
       */
  event NewPost(address indexed writer, uint256 postId, string title);

   /**
       * @dev This function creates a new post with unique IDs that are incremental
       * which helps keep track of posts.
       */
  function createPost(string memory title, string memory content) public {
    newPostId++;

    posts[newPostId] = Post(title, content, msg.sender, block.timestamp);
    authors[msg.sender].postId.push(newPostId);

    //Emit declares events that we want to trigger
    emit NewPost(msg.sender, newPostId, title);
  }

   /**
       * @dev Modify post title function gives the author the ability to
       * edit their post title.
       * We have placed a restriction that allows only the author to edit the post title.
       */
  function modifyPostTitle(uint256 postId, string memory title) public {
    require(msg.sender == posts[postId].writer, "Only the writer can modify title");

    posts[postId].title = title;
  }

   /**
       * @dev Modify post title function gives the author the ability to.
       * edit their post content.
       * We have placed a restriction that allows only the author to eidt the post content.
       */
  function modifyPostContent(uint256 postId, string memory content) public {
    require(msg.sender == posts[postId].writer, "Only the writer can modify contnet");

    posts[postId].content = content;
  }

   /**
       * @dev Update username function is for the author to be able to .
       * modify their username on the site.
       */
  function updateUsername(string memory username) public {
    authors[msg.sender].username = username;
  }

   /**
       * @dev Update bio function is for the author to be able to update.
       * their biography on the site.
       */
  function updateBio(string memory bio) public {
    authors[msg.sender].bio = bio;
  }

   /**
       * @dev Make donation fucntion allows the users to tip/donate to their favorite post/author.
       */
  function makeDonation(uint postId, uint donation) public payable {
    require(IERC20(maticTokenAddress).transferFrom(msg.sender, posts[postId]. writer, donation), "Transfer failed");
  }

   /**
       * @dev get post ids by writer function returns with an array of all posts by the same author.
       */
  function getPostIdsByWriter(address writer) public view returns (uint256[] memory) {
    return authors[writer].postId;
  }

   /**
       * @dev get post by id function gets the content of a particular post id.
       */
  function getPostById(uint256 postId) public view returns (string memory title, string memory content) {
    title = posts[postId].title;
    content = posts[postId].content;
  }
}