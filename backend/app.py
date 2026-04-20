from flask import Flask, request, jsonify, render_template, session, redirect, url_for, flash
from functools import wraps
from flask_cors import CORS
from config import Config
from models import db, Employee, User
import os

app = Flask(__name__, template_folder='../frontend', static_folder='../frontend')
CORS(app)
app.config.from_object(Config)

db.init_app(app)

with app.app_context():
    db.create_all()
    # Create default admin user if none exists
    if not User.query.filter_by(username='admin').first():
        admin = User(username='admin')
        admin.set_password('password')
        db.session.add(admin)
        db.session.commit()

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            if request.path.startswith('/api/'):
                return jsonify({'error': 'Unauthorized'}), 401
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# =========== Auth Routes ===========
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        data = request.form
        username = data.get('username')
        password = data.get('password')
        
        user = User.query.filter_by(username=username).first()
        if user and user.check_password(password):
            session['user_id'] = user.id
            return redirect(url_for('dashboard'))
            
        return render_template('login.html', error='Invalid username or password')
        
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('login'))

# =========== UI Routes ===========
@app.route('/')
@login_required
def dashboard():
    employee_count = Employee.query.count()
    total_salary = db.session.query(db.func.sum(Employee.salary)).scalar() or 0
    return render_template('dashboard.html', employee_count=employee_count, total_salary=total_salary)

@app.route('/employees')
@login_required
def employees_page():
    return render_template('employee.html')

@app.route('/add-employee')
@login_required
def add_employee_page():
    return render_template('add_employee.html')

# =========== API Routes ===========
@app.route('/api/employees', methods=['GET'])
@login_required
def get_employees():
    employees = Employee.query.all()
    return jsonify([emp.to_dict() for emp in employees]), 200

@app.route('/api/employees', methods=['POST'])
@login_required
def add_employee():
    data = request.json
    try:
        new_emp = Employee(
            first_name=data['first_name'],
            last_name=data['last_name'],
            email=data['email'],
            position=data['position'],
            department=data['department'],
            salary=int(data['salary'])
        )
        db.session.add(new_emp)
        db.session.commit()
        return jsonify(new_emp.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@app.route('/api/employees/<int:id>', methods=['DELETE'])
@login_required
def delete_employee(id):
    emp = Employee.query.get_or_404(id)
    db.session.delete(emp)
    db.session.commit()
    return jsonify({'message': 'Employee deleted'}), 200

if __name__ == '__main__':
    app.run(debug=True)
