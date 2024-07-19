// camera.js

// Function to get the camera stream and display it in the video element
function getCameraStream() {
    navigator.mediaDevices.getUserMedia({ video: true })
      .then(function(stream) {
        const video = document.getElementById('camera-preview');
        video.srcObject = stream;
        video.style.display = 'block'; // Ensure the video element is visible
        video.play();
      })
      .catch(function(err) {
        console.error('Error accessing camera: ', err);
        alert('No se pudo acceder a la cámara. Asegúrate de que la cámara esté conectada y vuelve a intentarlo.');
      });
  }
  
  // Function to capture an image from the video stream
  function captureImage() {
    const video = document.getElementById('camera-preview');
    if (!video.srcObject) {
      throw new Error('Camera stream not available');
    }
  
    // Create a canvas element to draw the video frame
    const canvas = document.createElement('canvas');
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const context = canvas.getContext('2d');
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
  
    // Return the image as a Data URL
    return canvas.toDataURL('image/png');
  }
  