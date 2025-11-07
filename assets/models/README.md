# TFLite Emotion Recognition Model

## Required File: emotion_model.tflite

You need to add a TFLite emotion recognition model file to this directory.

### Model Requirements:
- **File name**: `emotion_model.tflite`
- **Input**: 224x224x3 RGB image
- **Output**: 5 emotion classes (happy, sad, angry, surprised, neutral)
- **Format**: TensorFlow Lite (.tflite)

### Where to get the model:

#### Option 1: Pre-trained Models
1. **FER2013 Emotion Recognition**: 
   - Search for "FER2013 emotion recognition tflite" models
   - GitHub repositories like `opencv/opencv_zoo` or emotion recognition projects

2. **TensorFlow Hub**:
   - Visit https://tfhub.dev/
   - Search for "emotion recognition" or "facial expression"
   - Download and convert to .tflite format

3. **Hugging Face Models**:
   - Visit https://huggingface.co/models
   - Search for "emotion classification" 
   - Convert PyTorch/TensorFlow models to TFLite

#### Option 2: Convert Existing Model
If you have a Keras/TensorFlow model:

```python
import tensorflow as tf

# Load your trained model
model = tf.keras.models.load_model('emotion_model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

# Save the model
with open('emotion_model.tflite', 'wb') as f:
    f.write(tflite_model)
```

#### Option 3: Train Your Own
Use datasets like:
- FER2013
- CK+
- AffectNet
- RAF-DB

### Model Specifications:
- Input tensor: [1, 224, 224, 3] (batch, height, width, channels)
- Output tensor: [1, 5] (batch, num_classes)
- Classes order: [angry, happy, neutral, sad, surprised]

### Testing:
After adding the model, test it with:
```bash
flutter run
```

**Note**: TFLite models only work on physical Android/iOS devices, not in web browsers or simulators.