package;

import kha.Scheduler;
import kha.Game;
import kha.Framebuffer;
import kha.Color;
import kha.Loader;
import kha.graphics4.Program;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;

class Empty extends Game {

	// An array of 3 vectors representing 3 vertices to form a triangle
	static var vertices:Array<Float> = [
	   -1.0, -1.0, 0.0, // Bottom-left
	    1.0, -1.0, 0.0, // Bottom-right
	    0.0,  1.0, 0.0  // Top
	];
	// Indices for our triangle, these will point to vertices above
	static var indices:Array<Int> = [
		0, // Bottom-left
		1, // Bottom-right
		2  // Top
	];

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var program:Program;

	var startTime : Float = 0;

	public function new() {
		super("Empty");
	}

	override public function init() {
		// Define vertex structure
		var structure = new VertexStructure();
        structure.add("pos", VertexData.Float3);
        // Save length - we only store position in vertices for now
        // Eventually there will be texture coords, normals,...
        var structureLength = 3;

        // Load shaders - these are located in 'Sources/Shaders' directory
        // and Kha includes them automatically
		var fragmentShader = new FragmentShader(Loader.the.getShader("simple.frag"));
		var vertexShader = new VertexShader(Loader.the.getShader("simple.vert"));
	
		// Link program with fragment and vertex shaders we loaded
		program = new Program();
		program.setFragmentShader(fragmentShader);
		program.setVertexShader(vertexShader);
		program.link(structure);

		// Create vertex buffer
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);
		
		// Copy vertices to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i,vertices[i]);
		}
		vertexBuffer.unlock();

		// Create index buffer
		indexBuffer = new IndexBuffer(
			indices.length, // 3 indices for our triangle
			Usage.StaticUsage // Index data will stay the same
		);
		
		// Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
    }

	override public function render(frame:Framebuffer) {

		var duration = 1.0;
		var timeElapsed = Scheduler.time() - startTime;
		var ratio = timeElapsed / duration;

		if(ratio <= 1){
			// var g2 = frame.g2;
			// g2.begin();
			// g2.clear();
			// g2.color = Color.fromBytes(0, 255, 255);
			// g2.fillRect(frame.width / 4, frame.height / 2 - 10, ratio*100 * frame.width / 2 / 100, 20);
			// g2.color = Color.fromBytes(28, 28, 28);
			// g2.drawRect(frame.width / 4, frame.height / 2 - 10, frame.width / 2, 20);	
			// g2.end();	

			// A graphics object which lets us perform 3D operations
			var g = frame.g4;

			// Begin rendering
	        g.begin();

	        //g.viewport(0,0,frame.width,frame.height);

	        // Clear screen to black
			g.clear(Color.Black);

			// Bind shader program we want to draw with
			g.setProgram(program);

			// Bind data we want to draw
			g.setVertexBuffer(vertexBuffer);
			g.setIndexBuffer(indexBuffer);

			// Draw!
			g.drawIndexedVertices();

			// End rendering
			g.end();

		}else{
			
			// A graphics object which lets us perform 3D operations
			var g = frame.g4;



			// Begin rendering
	        g.begin();
	        g.clear(Color.Black);
	        var height = 100;
	        g.viewport(0,frame.height - height,frame.width,height);

	        // Clear screen to black
			

			// Bind shader program we want to draw with
			g.setProgram(program);

			// Bind data we want to draw
			g.setVertexBuffer(vertexBuffer);
			g.setIndexBuffer(indexBuffer);

			// Draw!
			g.drawIndexedVertices();

			// End rendering
			g.end();
		}

		
    }
}

