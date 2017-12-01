require_relative 'spec_helper'

RSpec.describe RubyRest do
  before :all do
    # RubyRest.config.bind = '35.196.169.169'
    # RubyRest.start_s/erver
  end

  after :all do
    # RubyRest.stop_server
  end

  context 'routes' do

    before :each do
      @post = Req.post('/posts', title: 'TEST', content: 'this is a test', access_token: Req::TOKEN1)
      @dog = Req.post('/dogs', name: 'Slippers', breed: 'american cocker spaniel', access_token: Req::TOKEN2)
    end

    context '/posts' do

      it 'should get all posts' do
        get = Req.get('/posts')
        expect(get.map { |e| e[:post_id] }.include?(@post[:post_id])).to eq true
      end
    end

    context '/post/:id' do

      it 'should get a single post' do
        get = Req.get("/posts/#{@post[:post_id]}")
        expect(get[:post_id]).to eq @post[:post_id]
      end

      it 'should delete a post' do
        Req.delete("/posts/#{@post[:post_id]}", Req::TOKEN1)
        begin
          get = Req.get("/posts/#{@post[:post_id]}")
        rescue => e
          get = e
        end
        expect(get.http_code).to eq 404
      end

      it 'should update a post' do
        Req.patch("/posts/#{@post[:post_id]}", title: 'Updated', access_token: Req::TOKEN1)
        get = Req.get("/posts/#{@post[:post_id]}")
        expect(get[:title]).to eq 'Updated'
      end

      it 'should replace a post' do
        Req.put("/posts/#{@post[:post_id]}", title: 'Replaced', content: 'replaced', access_token: Req::TOKEN1)
        get = Req.get("/posts/#{@post[:post_id]}")
        expect(get[:title]).to eq 'Replaced'
      end
    end

    context '/dogs' do

      it 'should get all dogs' do
        get = Req.get('/dogs')
        expect(get.map { |e| e[:dog_id] }.include?(@dog[:dog_id])).to eq true
      end

      context '/dogs/:id' do

        it 'should get a dog' do
          get = Req.get("/dogs/#{@dog[:dog_id]}")
          expect(get[:dog_id]).to eq @dog[:dog_id]
        end

        it 'should delete a dog' do
          Req.delete("/dogs/#{@dog[:dog_id]}", Req::TOKEN2)
          begin
            get = Req.get("/dogs/#{@dog[:dog_id]}")
          rescue => e
            get = e
          end
          expect(get.http_code).to eq 404
        end

        it 'should remove an associated dog from a post on delete' do
          post = Req.post('/posts', title: 'TEST', content: 'this is a test', access_token: Req::TOKEN2)
          Req.patch("/posts/#{post[:post_id]}", dog_ids: [@dog[:dog_id]], access_token: Req::TOKEN2)
          Req.delete("/dogs/#{@dog[:dog_id]}", Req::TOKEN2)
          get = Req.get("/posts/#{post[:post_id]}")
          expect(get[:dog_ids].include?(@dog[:dog_id])).to eq false
        end

        it 'should update a dog' do
          Req.patch("/dogs/#{@dog[:dog_id]}", name: 'Slip', access_token: Req::TOKEN2)
          get = Req.get("/dogs/#{@dog[:dog_id]}")
          expect(get[:name]).to eq 'Slip'
        end

        it 'should return all dogs in a breed' do
          dog = Req.post('/dogs', name: 'Slippers', breed: 'american cocker spaniel', access_token: Req::TOKEN2)
          get = Req.get('/dogs/breed/american_cocker_spaniel')
          expect(get.map { |e| e[:dog_id] }.include?(dog[:dog_id])).to eq true
        end

        it 'should replace a dog' do
          Req.put("/dogs/#{@dog[:dog_id]}", name: 'Slip', breed: 'corgi', access_token: Req::TOKEN2)
          get = Req.get("/dogs/#{@dog[:dog_id]}")
          expect(get[:name]).to eq 'Slip'
        end
      end
    end
    context 'Unauthenticated request' do
      it 'should fail on POST /dogs' do
        begin
          res = Req.post('/dogs', access_token: 'blah')
        rescue => e
          res = e
        end
        expect(res.http_code).to eq 401
      end

      it 'should fail on POST /posts' do
        begin
          res = Req.post('/posts', access_token: 'blah')
        rescue => e
          res = e
        end
        expect(res.http_code).to eq 401
      end
      it 'should fail on PATCH /posts/:id' do
        begin
          res = Req.patch('/posts/someid', access_token: 'blah')
        rescue => e
          res = e
        end
        expect(res.http_code).to eq 401
      end
      it 'should fail on PATCH /dogs/:id' do
        begin
          res = Req.patch('/dogs/someid', access_token: 'blah')
        rescue => e
          res = e
        end
        expect(res.http_code).to eq 401
      end
      it 'should fail on DELETE /posts/:id' do
        begin
          res = Req.delete('/dogs/someid', 'blah')
        rescue => e
          res = e
        end
        expect(res.http_code).to eq 401
      end
    end

    context 'Unauthorized' do
      context 'Access to unauthorized resources' do

        before :each do
          @post = Req.post('/posts', title: 'TEST', content: 'this is a test', access_token: Req::TOKEN1)
          @dog = Req.post('/dogs', name: 'Slippers', breed: 'american cocker spaniel', access_token: Req::TOKEN1)
        end

        it 'should fail on update posts' do
          begin
            res = Req.patch("/posts/#{@post[:post_id]}", access_token: Req::TOKEN2)
          rescue => e
            res = e
          end
          expect(res.http_code).to eq 401
        end
        it 'should fail on delete posts' do
          begin
            res = Req.delete("/posts/#{@post[:post_id]}", access_token: Req::TOKEN2)
          rescue => e
            res = e
          end
          expect(res.http_code).to eq 401
        end
        it 'should fail on update dogs' do
          begin
            res = Req.patch("/dogs/#{@dog[:dog_id]}", access_token: Req::TOKEN2)
          rescue => e
            res = e
          end
          expect(res.http_code).to eq 401
        end
        it 'should fail on delete dogs' do
          begin
            res = Req.delete("/dogs/#{@dog[:dog_id]}", Req::TOKEN2)
          rescue => e
            res = e
          end
          expect(res.http_code).to eq 401
        end
      end
    end
  end
end

