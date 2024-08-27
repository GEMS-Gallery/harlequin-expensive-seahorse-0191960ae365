import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Time "mo:base/Time";
import List "mo:base/List";
import Debug "mo:base/Debug";

actor {
  // Define the Post type
  public type Post = {
    id: Nat;
    title: Text;
    body: Text;
    author: Text;
    timestamp: Time.Time;
  };

  // Stable variable to store posts
  stable var posts : List.List<Post> = List.nil();
  stable var nextId : Nat = 0;

  // Create a new post
  public func createPost(title: Text, body: Text, author: Text) : async Nat {
    let post : Post = {
      id = nextId;
      title = title;
      body = body;
      author = author;
      timestamp = Time.now();
    };
    posts := List.push(post, posts);
    nextId += 1;
    Debug.print("New post created with ID: " # debug_show(post.id));
    post.id
  };

  // Get all posts
  public query func getPosts() : async [Post] {
    List.toArray(posts)
  };

  // System functions for upgrades
  system func preupgrade() {
    Debug.print("Preparing to upgrade. Current post count: " # debug_show(List.size(posts)));
  };

  system func postupgrade() {
    Debug.print("Upgrade complete. New post count: " # debug_show(List.size(posts)));
  };
}
