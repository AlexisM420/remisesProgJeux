using Godot;
using System;

public class Gui : MarginContainer
{
	private Label _numberLabel;
	private TextureProgress _bar;
	private Tween _tween;

	private float _animatedHealth;

	public override void _Ready()
	{
		// Setup private vars for existing nodes on instancing
		_bar = (TextureProgress) GetNode("Bars/LifeBar/TextureProgress");
		_tween = (Tween) GetNode("Tween");
		_numberLabel = (Label) GetNode("Bars/LifeBar/Count/Background/Number");
		_animatedHealth = 0;
		
		// Sets progBar max value to player hp maxValue
		var player = (Player) GetNode("../Characters/Player");
		_bar.MaxValue = player.MaxHealth;
		
		// Instancing the number label health
		UpdateHealth(player.MaxHealth);
	}

	// Gets called after signal received
		// Updates number label HP
	private void UpdateHealth(int newHealth)
	{
		// OLD
		/*
		_numberLabel.Text = newHealth.ToString();
		_bar.Value = newHealth;
		*/

		// NEW
		_tween.InterpolateProperty(
			this, 
			"_animatedHealth", 
			_animatedHealth, 
			newHealth, 
			0.6f, 
			Tween.TransitionType.Linear, 
			Tween.EaseType.In );

		if (!_tween.IsActive())
		{
			_tween.Start();
		}
	}

	#region SIGNALS
	void _on_Player_HealthChanged(int playerHealth)
	{
		UpdateHealth(playerHealth);
	}
	void _on_Player_Died()
	{
		var startColor = new Color(1.0f, 1.0f, 1.0f);		// white full opacity
		var endColor = new Color(1.0f, 1.0f, 1.0f, 0.0f);   // pure white full transparent

		_tween.InterpolateProperty(
			this, 
			"modulate",
			startColor, 
			endColor,
			1.0f, 
			Tween.TransitionType.Linear,
			Tween.EaseType.In );

		// NEVER FORGET IT - But here, consider that we'll update health before he dies *logic*
		/*
		if (!_tween.IsActive())
		{
			_tween.Start();
		}
		*/
	}
	#endregion

	// "Done at every FPS"
	public override void _Process(float delta)
	{
		var roundValue = Mathf.Round(_animatedHealth);

		_numberLabel.Text = roundValue.ToString();
		_bar.Value = roundValue;
	}
}



