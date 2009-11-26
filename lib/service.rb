module Idology
  class Service
    include HTTParty
    base_uri 'https://web.idologylive.com/api'
    attr_accessor :api_search_response, :api_question_response, :api_verification_response, :api_challenge_question_response, :api_challenge_verification_response

    def default_options
      {
        :pem => File.dirname(__FILE__) + '/certs/cacert.pem',
        :parser => lambda{|r| Response.parse(r)}
      }
    end

    def locate(subject)
      # locate is an IDology ExpectID API call - only checks to see if a person is available in the system
      # if available, further API calls can be made to verify the person's identity via ExpectID IQ questions

      # new SearchRequest Object
      search_request = SearchRequest.new

      # assemble the data in a hash for the POST
      search_request.set_data(subject)

      # make the call
      response = post(search_request.url, search_request.data)
      self.api_search_response = Response.parse(response)
    end

    def get_questions(subject)
      # get_questions is an IDology ExpectID IQ API call - which given a valid idNumber from an ExpectID API call
      # should return three questions that can be asked to verify the ID of the person in question

      # new VerificationQuestionsRequest object
      question_request = VerificationQuestionsRequest.new

      # assemble the data in a hash for the POST
      question_request.set_data(subject)

      # make the call
      response = post(question_request.url, question_request.data)
      self.api_question_response = Response.parse(response)
    end

    def submit_answers(subject)
      # submit questions / answers to the IDology ExpectID IQ API

      verification_request = VerificationRequest.new

      # assemble the data for POST
      verification_request.set_data(subject)

      # make the call
      response = post(verification_request.url, verification_request.data)
      self.api_verification_response = Response.parse(response)
    end

    def get_challenge_questions(subject)
      # get_challenge_questions is an IDology ExpectID Challenge API call - given a valid idNumber from an ExpectID IQ question
      # and response process, will return questions to further verify the subject

      question_request = ChallengeQuestionsRequest.new

      # assemble the data
      question_request.set_data(subject)

      # make the call
      response = post(question_request.url, question_request.data)
      self.api_challenge_question_response = Response.parse(response)
    end

    def submit_challenge_answers(subject)
      # submit question type / answers to the IDology ExpectID Challenge API

      challenge_verification_request = ChallengeVerificationRequest.new

      # assemble the data
      challenge_verification_request.set_data(subject)

      # make the call
      response = post(challenge_verification_request.url, challenge_verification_request.data)
      self.api_challenge_verification_response = Response.parse(response)
    end
  end
end