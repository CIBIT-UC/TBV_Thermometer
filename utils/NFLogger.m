classdef NFLogger < Logger
   %SINGLETONIMPL Concrete Implementation of Singleton OOP Design Pattern
   %   Refer to the description in the abstract superclass Singleton for
   %   full detail.
   %   This class serves as a template for constructing your own custom
   %   classes.
   %
   %   Written by Bobby Nedelkovski
   %   The MathWorks Australia Pty Ltd
   %   Copyright 2009, The MathWorks, Inc.
   
   properties % Public Access
      startTime = 0;
   end
   
   methods(Access=private)
      % Guard the constructor against external invocation.  We only want
      % to allow a single instance of this class.  See description in
      % Singleton superclass.
      function newObj = NFLogger()
          newObj.startTime = now;
      end
      
      function time = getTime(obj)
         time = now - obj.startTime; 
      end
      
   end
   
   methods(Static)
      % Concrete implementation.  See Singleton superclass.
      function obj = getLogger()
         persistent uniqueInstance
         if isempty(uniqueInstance)
            obj = NFLogger();
            uniqueInstance = obj;
         else
            obj = uniqueInstance;
         end
      end
   end
   
   %*** Define your own methods for SingletonImpl.
   methods % Public Access
      function log(obj, val, verbose)
          if nargin < 3
              verbose = 0;
          end
          
          text = sprintf('%.4f - %s', obj.getTime(), val);
          
          if verbose
              disp( text );
          end
          % Just assign the input value to singletonData.  See Singleton
          % superclass.
          obj.addToLog( text );
      end
      
      
      function saveToFile(obj, filename)
          f = fopen(filename, 'w');
          fwrite( f, obj.getLoggedData() );
          fclose( f );
          
          fprintf('Log salvo com sucesso no ficheiro %s\n', filename);
          obj.clearLog();
      end
   end
   
end
