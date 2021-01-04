require("eyesy")

modeTitle = "morph"       -- name the mode

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter
w8 = w / 8                  -- width 8th
h8 = h / 8                  -- height 8th
w16 = w / 16                  -- width 16th
h16 = h / 16                  -- height 16th
c = glm.vec3( w2, h2, 0 )   -- center in glm vector

num=8

----------------------------------------------------
function setup()
    of.noFill()
	  bg = of.Color(0,0,0,0)
	  fg = of.Color()

    startTime = of.getElapsedTimeMillis();
    bTimerReached = false
    position = 0.1;
    speed = 60;

    --------------------- define light
    myLight = of.Light()                -- define a light class
    myLight:setPointLight()
    --myLight:setSpotlightCutOff(.1)
  	myLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- and make the ambient color white
  	myLight:setSpecularColor( of.FloatColor( 255, 255, 255 ) ) 
    myLight:setPosition( c + glm.vec3(w16,-h4,h4) ) -- and set the position in the center with z closer
  
--   	knob3 = 0.5
--   	knob4 = 0.1
   	knob5 = 0.3
    --of.setLineWidth(1)
end

----------------------------------------------------
function update()
  --colorPickHsb( knob5, bg )
  of.setBackgroundColor( bg )

  elapsed = of.getElapsedTimeMillis() - startTime;
  if (elapsed >= speed and not bTimerReached) then
      bTimerReached = true       
      startTime = of.getElapsedTimeMillis()
      position = position + 0.01;
      if position > 1 then
        position = 0
      end
  else 
    bTimerReached = false
  end


end

----------------------------------------------------
function draw()
    -- OSD
    osd.osd_button (osd_state)

    amplitude = 1000 + knob3*4000   

    --of.setLineWidth(knob4 * 10+1)   

--    of.noFill()
    
    
    of.enableLighting()             -- enable lighting globally
    of.enableDepthTest()            -- enable 3D rendering globally
--    of.enableAlphaBlending()
    myLight:enable()                -- begin rendering for myLight

    of.pushMatrix()

    of.translate(20, h/2)
    of.rotateXDeg(knob1*180)
--    of.rotateYDeg(knob2*180)
--    of.rotateXDeg(position*2*180)
--    of.rotateYDeg(position*2*180)

    offset = 256/num
    for i=1,num do
        xPos = i * w/10
        
        audioR = math.abs(inR[ i * (256/num)] )
        audioL = math.abs(inL[ i * (256/num)] )
        colorPickHsb(  knob5 + audioL/2, fg )
        of.setColor( fg )
        of.noFill()
        
        if knob2 <= .3 then 
          of.drawBox(glm.vec3(xPos, 0, h16/2 + inL[i*offset]*amplitude/8), h8+ inL[i*offset]*amplitude/20)
        elseif knob2 > .3 and knob2 < .8 then
          of.drawSphere(glm.vec3(xPos, 0, h16/2 + inR[i*offset]*amplitude/8), h8+ inR[i*offset]*amplitude/20)
        else
         of.drawCylinder(glm.vec3(xPos, 0, h16/2 + inR[i*offset]*amplitude/8), h8+ inR[i*offset]*amplitude/20, h4)
        end
        
        
--        of.setCircleResolution(100)
--        of.drawCircle(glm.vec3((-h4*knob4)-h4, 0, -h16/2 + inL[i*offset]*amplitude/8), inL[i*offset]*amplitude/2)  --           
--        colorPickHsb(  knob5 + audioR/2, fg )
--        of.setColor( fg )
--        of.noFill()
--        of.setCircleResolution(100)
--        of.drawCircle(glm.vec3((h4*knob4)+h4, 0, h16/2 + inR[i*offset]*amplitude/8), inR[i*offset]*amplitude/2)

    end
    of.popMatrix()

    myLight:disable()               -- end rendering for myLight
    of.disableLighting()            -- disable lighting globally

end

----------------------------------------------------
function draw3DScope(a, b, amplitude, axis, vertices)
    local stepx = (b.x - a.x) / vertices--256 max vertices
    local stepy = (b.y - a.y) / vertices--256 max vertices
    local stepz = (b.z - a.z) / vertices--256 max vertices
    of.beginShape()
    for i=1,vertices do
        if axis == 1 then
            of.vertex(a.x + stepx*i + inL[i]*amplitude, a.y + stepy*i, a.z + stepz*i)
        end
        if axis == 2 then
            of.vertex(a.x + stepx*i, a.y + stepy*i + inL[i]*amplitude, a.z + stepz*i)
        end
        if axis == 3 then
            of.vertex(a.x + stepx*i, a.y + stepy*i, a.z + stepz*i + inL[i]*amplitude)
        end
    end
    of.endShape()
end

------------------------------------ Color Function
-- this is how the knobs pick color
function colorPickHsb( knob, name )
	-- middle of the knob will be bright RBG, far right white, far left black
	
	k6 = (knob * 5) + 1						-- split knob into 8ths
	hue = (k6 * 255) % 255 
	kLow = math.min( knob, 0.49 ) * 2		-- the lower half of knob is 0 - 1
	kLowPow = math.pow( kLow, 2 )
	kH = math.max( knob, 0.5 ) - 0.5	
	kHigh = 1 - (kH*2)						-- the upper half is 1 - 0
	kHighPow = math.pow( kHigh, 0.5 )
	
	bright = kLow * 255						-- brightness is 0 - 1
	sat = kHighPow * 255					-- saturation is 1 - 0
	
	name:setHsb( hue, sat, bright )			-- set the ofColor, defined above
end


----------------------------------------------------
function exit()
	print("script finished")
end